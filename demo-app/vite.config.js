import { defineConfig } from "vite";

export default defineConfig({
  define: { __BUILT_AT__: JSON.stringify(Date.now()) },
  build: { outDir: "dist" },
});
