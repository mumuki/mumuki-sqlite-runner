#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <fstream>
#include <iostream>
#include <sstream>
#include <string>
#include <algorithm>


using namespace std;

void writeFile (string filename, string buffer) {
  ofstream file;
  file.open (filename);
  file << buffer << endl;
  file.close();
}

/**
 * Save each code-block in a separated file
 * Block starts with a sql-comment-tag `-- TAG`
 */
int main(int argc, char** argv) {

    if (argc <= 1) {
        printf("Error: file needed as argument.\n");
        exit(EXIT_FAILURE);
    }

    // point to file-name argument
    ifstream infile (argv[1]);

    const string TAG = "-- ";
    string line;
    string current_block;
    vector<string> blocks;

    string buffer;
    string block_name;
    string filename = ".trash";

    while (getline(infile, line)) {

        // is TAG header
        if (line.compare(0, TAG.length(), TAG) == 0) {
            // flush buffer
            writeFile (filename, buffer);

            // get new block name
            block_name = line;
            block_name = line.substr(TAG.length(), line.length());
            transform(block_name.begin(), block_name.end(), block_name.begin(), ::tolower);

            // set new tmp vars
            filename = "mql_" + block_name + ".sql";
            buffer.clear();
        }

        // save line
        buffer += line + "\n";
    }

    // flush last block
    writeFile (filename, buffer);

    return 0;
}
