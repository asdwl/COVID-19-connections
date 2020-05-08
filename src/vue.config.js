module.exports = {
  "transpileDependencies": [
    "vuetify"
  ],
  // Configure the webpack dev server behavior.
  devServer: {
      open: process.platform === 'darwin',
      host: '0.0.0.0',
      port: 8080,
      https: false,
      hotOnly: false,
      // See https://github.com/vuejs/vue-docs-zh-cn/blob/master/vue-cli/cli-service.md#Configuration agent
      proxy: {
          '/api': {
              target: 'http://127.0.0.1:3000/api/',
              changeOrigin: true,
              secure: false,
              pathRewrite: {
                  "^/api": ""
              }
          }
      },
      disableHostCheck: true
  },
}