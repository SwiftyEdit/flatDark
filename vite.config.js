import { defineConfig } from 'vite';
import autoprefixer from 'autoprefixer';
import cssnano from 'cssnano';
import fs from 'fs-extra';
import path from 'path';

/**
 * Every *.scss file directly under src/scss/skins/ becomes its own CSS-only
 * build entry, output to dist/skins/<name>.css. This is the "Stylesheet"
 * (color variant) picker under Admin -> Addons -> Themes - see
 * acp/core/addons/data-reader.php, which globs this same dist/skins/
 * directory to build the picker, and templates/head.tpl, which links the
 * selected one in after theme.css. Same convention as the default theme,
 * see docs/v2/de/09-01-00-themes.md ("Farbvarianten (Stylesheets)").
 */
function discoverSkinEntries() {
    const dir = 'src/scss/skins';
    const entries = {};
    if (!fs.existsSync(dir)) {
        return entries;
    }
    for (const file of fs.readdirSync(dir)) {
        // Leading underscore = a Sass partial (e.g. _skin-tokens.scss),
        // meant to be @imported by actual skins, not built standalone.
        if (file.endsWith('.scss') && !file.startsWith('_')) {
            entries[`skins/${path.basename(file, '.scss')}`] = `./${dir}/${file}`;
        }
    }
    return entries;
}

function copyAssets() {
    return {
        name: 'copy-assets',
        closeBundle() {
            const copies = [
                { src: 'node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff',  dest: 'dist/fonts/bootstrap-icons.woff' },
                { src: 'node_modules/bootstrap-icons/font/fonts/bootstrap-icons.woff2', dest: 'dist/fonts/bootstrap-icons.woff2' },
                { src: 'src/editor.css',        dest: 'dist/editor.css' },
                { src: 'src/tinyMCE_config.js', dest: 'dist/tinyMCE_config.js' },
            ];
            for (const { src, dest } of copies) {
                fs.copySync(src, dest, { overwrite: true });
                console.log(`✓ Copied ${src} → ${dest}`);
            }
        }
    };
}

export default defineConfig({
    build: {
        outDir: 'dist',
        emptyOutDir: true,
        minify: 'terser',
        terserOptions: {
            keep_classnames: true,
            keep_fnames: true,
        },
        rollupOptions: {
            input: {
                theme: './src/js/frontend.js',
                ...discoverSkinEntries(),
            },
            output: {
                entryFileNames: '[name].js',
                chunkFileNames: '[name].js',
                assetFileNames: (assetInfo) => {
                    if (assetInfo.name?.endsWith('.css')) return '[name].css';
                    return 'assets/[name][extname]';
                },
                format: 'es',
            },
        },
    },
    css: {
        preprocessorOptions: {
            scss: {},
        },
        postcss: {
            plugins: [
                autoprefixer,
                cssnano({ preset: 'default' }),
            ],
        },
    },
    plugins: [
        copyAssets(),
    ],
});
