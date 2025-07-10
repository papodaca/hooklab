# ================================
# Frontend Build Stage
# ================================
FROM node:20 AS frontend-build
WORKDIR /app
COPY package.json yarn.lock ./
RUN yarn install
COPY index.html .
COPY tailwind.config.js .
COPY svelte.config.js .
COPY vite.config.js .
COPY Frontend/ ./Frontend/
RUN yarn build

# ================================
# Build image
# ================================
FROM swift:6.1-bookworm AS build

# Install OS updates
RUN export DEBIAN_FRONTEND=noninteractive DEBCONF_NONINTERACTIVE_SEEN=true \
    && apt-get -q update \
    && apt-get -q dist-upgrade -y \
    && apt-get install -y libjemalloc-dev

# Set up a build area
WORKDIR /build

# First just resolve dependencies.
# This creates a cached layer that can be reused
# as long as your Package.swift/Package.resolved
# files do not change.
COPY ./Package.* ./
RUN swift package resolve \
        $([ -f ./Package.resolved ] && echo "--force-resolved-versions" || true)

# Copy entire repo into container
COPY . .

# Copy built frontend assets from the frontend-build stage
COPY --from=frontend-build /app/Public ./Public

# Build the application, with optimizations, with static linking, and using jemalloc
# N.B.: The static version of jemalloc is incompatible with the static Swift runtime.
RUN swift build -c release \
        --product hooklab \
        --static-swift-stdlib \
        -Xlinker -ljemalloc

# Switch to the staging area
WORKDIR /staging

# Copy main executable to staging area
RUN cp "$(swift build --package-path /build -c release --show-bin-path)/hooklab" ./

# Copy static swift backtracer binary to staging area
RUN cp "/usr/libexec/swift/linux/swift-backtrace-static" ./

# Copy resources bundled by SPM to staging area
RUN find -L "$(swift build --package-path /build -c release --show-bin-path)/" -regex '.*\.resources$' -exec cp -Ra {} ./ \;

# ================================
# Run image
# ================================
FROM gcr.io/distroless/cc-debian12

# Copy required libraries from the build stage
COPY --from=build /usr/lib/x86_64-linux-gnu/libjemalloc.so.2 /usr/lib/x86_64-linux-gnu/
COPY --from=build /usr/lib/x86_64-linux-gnu/libz.so.1 /usr/lib/x86_64-linux-gnu/

# Set the working directory
WORKDIR /app

# Copy built executable and any staged resources from builder
# The nonroot user has UID 65532.
COPY --from=build --chown=65532:65532 /staging /app

# Provide configuration needed by the built-in crash reporter and some sensible default behaviors.
ENV SWIFT_BACKTRACE=enable=yes,sanitize=yes,threads=all,images=all,interactive=no,swift-backtrace=./swift-backtrace-static

# Let Docker bind to port 8080
EXPOSE 8080

# Start the Vapor service when the image is run, default to listening on 8080 in production environment
ENTRYPOINT ["./hooklab"]
CMD ["serve", "--env", "production", "--hostname", "0.0.0.0", "--port", "8080"]
