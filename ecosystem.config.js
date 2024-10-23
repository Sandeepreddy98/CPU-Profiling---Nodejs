module.exports = {
    apps: [
      {
        name: "node-performance-profiling",
        script: "./index.js", // replace with your main script
        node_args: "--prof --logfile=./v8-logs/isolate-%p-v8.log --perf-basic-prof-only-functions",
        // node_args: "--prof",
        // Other PM2 configurations
        instances: 2,
        autorestart: true,
        watch: false,
        max_memory_restart: "1G",
        env: {
          NODE_ENV: "development",
        },
        env_production: {
          NODE_ENV: "production",
        },
      },
    ],
  };
  