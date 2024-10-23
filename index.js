// const inspector = require('inspector');
const fs = require('fs');
const path = require('path');
const express = require('express');
const app = express();
const port = 3000;

const directoryPath = __dirname

app.use((req, res, next) => {
  next()
})
// const session = new inspector.Session();
// session.connect();

function cpuIntensiveTask(duration) {
    const start = Date.now();
    while (Date.now() - start < duration) {
      // Perform some intensive calculations
      for (let i = 0; i < 1e6; i++) {
        Math.sqrt(Math.random());
        Math.log(Math.random());
        Math.pow(Math.random(), 2);
      }
    }
    // console.log('CPU intensive task completed');
  }
  
//   // Example usage: Run for 5 seconds
//   cpuIntensiveTask(5000);
  

// Simulate a memory-intensive task
function memoryIntensiveTask(size) {
    const arr = [];
    for (let i = 0; i < size; i++) {
      // Create a large string and push it into the array
      arr.push(new Array(1000).fill('x').join(''));
    }
    // console.log('Memory intensive task completed');
    return arr;
  }
  
//   // Example usage: Create an array with a specified number of large strings
//   const result = memoryIntensiveTask(1e5);
//   console.log('Array size:', result.length);
  

function startProfiling(profileName, duration) {
  return new Promise((resolve) => {
    session.post('Profiler.enable', () => {
      session.post('Profiler.start', () => {
        setTimeout(() => {
          session.post('Profiler.stop', (err, { profile }) => {
            if (!err) {
              fs.writeFileSync(profileName, JSON.stringify(profile));
              // console.log(`Profile saved as ${profileName}`);
            }
            resolve();
          });
        }, duration);
      });
    });
  });
}

app.get('/cpu', async (req, res) => {
  // await startProfiling('cpu-profile.cpuprofile', 5000);
  cpuIntensiveTask(5000); // Run CPU-intensive task for 5 seconds
  res.send('CPU-intensive task completed');
});

app.get('/memory', async (req, res) => {
  // await startProfiling('memory-profile.cpuprofile', 5000);
  memoryIntensiveTask(1e5); // Allocate memory
  res.send('Memory-intensive task completed');
});

app.get('/callbacks',(req,res)=>{
  res.send(callbacks())
})

app.get('/async-await',(req,res)=>{

})

app.get('/promise',(req,res) => {
  res.send(promise())
})

function callbacks(){
  setTimeout(function firstCallback(){
    setTimeout(function secondCallback(){
      setTimeout(function thirdCallback(){
        return 'callBack hell executed!'
      },40000)
    },20000)
  },30000)
}

function promise(){
  return new Promise(function promiseInternal(resolve,reject){
    setTimeout(() => {
      const result  = cpuIntensiveTask(5000);
      resolve('Promise executed! : ' ,result)
    }, 100000);
  })
}

// Flame graph visualisation
app.get('/flame-graph', async (req, res) => {
    res.sendFile(__dirname+'/perf-flamegraph.svg')
});

// using linux perf
app.get('/perf-events', async (req, res) => {
  res.sendFile(__dirname+'/processed.txt')
});

function deleteFiles() {
  fs.readdir(directoryPath, (err, files) => {
    if (err) {
      return console.log('Unable to scan directory: ' + err);
    }

    // Filter files that start with "isolate"
    const isolateFiles = files.filter(file => file.startsWith('isolate'));

    // Delete each file
    isolateFiles.forEach(file => {
      const filePath = path.join(directoryPath, file);
      fs.unlink(filePath, err => {
        if (err) {
          console.error(`Error deleting file ${file}:`, err);
        } else {
          console.log(`Deleted file: ${file}`);
        }
      });
    });
  });
}

app.get('/', (req, res) => {
  res.send('Hello, world!');
});

app.listen(port, () => {
  console.log(`App running at http://localhost:${port}`);
});
