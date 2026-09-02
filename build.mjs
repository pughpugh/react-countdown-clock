import * as esbuild from "esbuild";

const sharedOptions = {
	entryPoints: ["src/index.jsx"],
	bundle: true,
	minify: true,
	external: ["react", "prop-types"], // Peer dependencies
	loader: { ".jsx": "jsx" },
};

async function build() {
	// Build CommonJS
	await esbuild.build({
		...sharedOptions,
		outfile: "build/index.js",
		format: "cjs",
	});

	// Build ES Modules
	await esbuild.build({
		...sharedOptions,
		outfile: "build/index.esm.js",
		format: "esm",
	});

	console.log("Build complete!");
}

build().catch(() => process.exit(1));
