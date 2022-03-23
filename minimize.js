const fs = require('fs');
var luamin = require('luamin');

fs.rmdir('./dist', { recursive: true }, (err) => {
    if (err) {
        throw err;
    }

    fs.mkdirSync('./dist');
    fs.mkdirSync('./dist/scripts');
    fs.mkdirSync('./dist/scripts/stats');
    fs.mkdirSync('./dist/ui_scripts');
    fs.mkdirSync('./dist/ui_scripts/stats');
    fs.mkdirSync('./dist/ui_scripts/stats/common');
    fs.mkdirSync('./dist/ui_scripts/stats/menus');

    fs.readdir('./scripts/stats/', (err, files) => {
        files.forEach(file => {
            const buffer = fs.readFileSync('./scripts/stats/' + file);
            const fileContent = buffer.toString();
            var test = luamin.minify(fileContent);
            fs.writeFile('./dist/scripts/stats/' + file, test, function() {})
        });
    });

    const buffer = fs.readFileSync('./ui_scripts/stats/' + '__init__.lua');
    const fileContent = buffer.toString();
    var test = luamin.minify(fileContent);
    fs.writeFile('./dist/ui_scripts/stats/' + '__init__.lua', test, function() {})

    fs.readdir('./ui_scripts/stats/common/', (err, files) => {
        files.forEach(file => {
            const buffer = fs.readFileSync('./ui_scripts/stats/common/' + file);
            const fileContent = buffer.toString();
            var test = luamin.minify(fileContent);
            fs.writeFile('./dist/ui_scripts/stats/common/' + file, test, function() {})
        });
    });

    fs.readdir('./ui_scripts/stats/menus/', (err, files) => {
        files.forEach(file => {
            const buffer = fs.readFileSync('./ui_scripts/stats/menus/' + file);
            const fileContent = buffer.toString();
            var test = luamin.minify(fileContent);
            fs.writeFile('./dist/ui_scripts/stats/menus/' + file, test, function() {})
        });
    });
});
