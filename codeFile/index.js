const { exec, execSync } = require('child_process');
const express = require("express")
const cors = require("cors")
const path = require('path');
const fs = require("fs");



// field declarations
const PORT = process.env.PORT || 3000


const app = express()
// port dependecies
app.use(cors())
app.use(express.json())
app.use(express.urlencoded({ extended: true })) 




app.get('/',function(req,res) {
    res.sendFile(path.join(__dirname+'/index.html'));
});

app.post('/magicSquare', (req, res) => {

    // init
    const magicNumber = req.body.magicNumber
    const size = req.body.size
    let inputStatus = false
    let isSolutionFound = false
    let solution = []



    console.log(magicNumber,size)

    // check input
    if(!isNaN(magicNumber) && !isNaN(size)){
        inputStatus = true
    }


    // cmd execution
    let cmdString = `swipl -l './prolog/magicSquare.pl' -g 'buildOutput(${size},${magicNumber}).' -g halt`
    
    // control messages

    let Error = ""
    let Stdout = ""
    let Stderr = ""

    if(inputStatus){
        
        // swipl cmd to produce magic square
        exec(cmdString, (error, stdout, stderr) => {
            if (error) {
                Error = error.message
                console.log(`error: ${error.message}`)
                return
            }
            if (stderr) {
                Stderr = stderr
                console.log(`stderr: ${stderr}`)
                return
            }
            
            // stream consoles
            Stdout = stdout

            // read file
            let textByLine = [];
            let text = fs.readFileSync("./prolog/output.txt", 'utf-8')
            textByLine = text.split('\n')

            // manipulating data
            textByLine.pop()

            let numRows = textByLine.length
            // let numSolutions = numRows/size

            if(numRows > 0){
                isSolutionFound = true

                for(let i=0; i<numRows; i++){
                    textByLine[i] = textByLine[i].slice(0, textByLine[i].length - 1)
                    textByLine[i] = JSON.parse(textByLine[i])
                }

                for(let i=0; i<numRows; i = i + parseInt(size)){
                    let pairMatrix = []

                    for(let j=0; j<parseInt(size); j++){
                        pairMatrix.push(textByLine[i+j])
                    }
                    
                    

                    solution.push(pairMatrix)
                }

            }

            // create object

            res.status(200).json({
                inputStatus: inputStatus,
                isSolutionFound: isSolutionFound,
                solution: solution,
            })

        });

    }


    

})



app.listen(PORT,() => {
    console.log("SERVER STARTED")    
})
