const fs = require('fs');
var luamin = require('luamin');

function logic() {
    console.log("Creating directories...");

    fs.mkdirSync('./dist');
    fs.mkdirSync('./dist/stats');
    fs.mkdirSync('./dist/stats/scripts');
    fs.mkdirSync('./dist/stats/scripts/stats');
    fs.mkdirSync('./dist/stats/ui_scripts');
    fs.mkdirSync('./dist/stats/ui_scripts/stats');
    fs.mkdirSync('./dist/stats/ui_scripts/stats/common');
    fs.mkdirSync('./dist/stats/ui_scripts/stats/menus');

    fs.readdir('./scripts/stats/', (err, files) => {
        files.forEach(file => {
            const buffer = fs.readFileSync('./scripts/stats/' + file);
            const fileContent = buffer.toString();
            var test = luamin.minify(fileContent);
            fs.writeFile('./dist/stats/scripts/stats/' + file, test, function() {})
        });
    });

    const buffer = fs.readFileSync('./ui_scripts/stats/' + '__init__.lua');
    const fileContent = buffer.toString();
    var test = luamin.minify(fileContent);
    fs.writeFile('./dist/stats/ui_scripts/stats/' + '__init__.lua', test, function() {})

    fs.readdir('./ui_scripts/stats/common/', (err, files) => {
        files.forEach(file => {
            const buffer = fs.readFileSync('./ui_scripts/stats/common/' + file);
            const fileContent = buffer.toString();
            var test = luamin.minify(fileContent);
            fs.writeFile('./dist/stats/ui_scripts/stats/common/' + file, test, function() {})
        });
    });

    fs.readdir('./ui_scripts/stats/menus/', (err, files) => {
        files.forEach(file => {
            const buffer = fs.readFileSync('./ui_scripts/stats/menus/' + file);
            const fileContent = buffer.toString();
            var test = luamin.minify(fileContent);
            fs.writeFile('./dist/stats/ui_scripts/stats/menus/' + file, test, function() {})
        });
    });

    fs.copyFile('info.json', './dist/stats/info.json', (err) => {
        if (err) throw err;
    });

    console.log("Job finished.");
}

if (fs.existsSync('./dist')) {
    fs.rm('./dist', { recursive: true }, (err) => {
        if (err) {
            console.log(err);
            throw err;
        }
    
        logic();
    });
} else {
    logic();
}