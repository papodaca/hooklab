import Foundation
import PackagePlugin

@main
struct GenerateAssets: BuildToolPlugin {
    func createBuildCommands(context: PluginContext, target: Target) async throws -> [Command] {
        let generatorTool = try context.tool(named: "asset-generator")
        let inputFile = context.package.directoryURL.appendingPathComponent("Public")
        let outputFile = context.pluginWorkDirectoryURL.appendingPathComponent("EmbeddedAssets.swift")

        return [
            .buildCommand(
                displayName: "Generating EmbeddedAssets.swift from \(inputFile.lastPathComponent)",
                executable: generatorTool.path,
                arguments: [inputFile.path, outputFile.path],
                inputFiles: [Path(inputFile.path)],
                outputFiles: [Path(outputFile.path)]
            )
        ]
    }
}
