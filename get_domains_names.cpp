#include "domains_names.h"

string exec_command_and_return_result(const char* cmd) {
    shared_ptr<FILE> pipe(popen(cmd, "r"), pclose);
    if (!pipe)
        return "ERROR";
    char buffer[4096];
    string result = "";
    while (!feof(pipe.get())) {
        if (fgets(buffer, 4096, pipe.get()) != NULL)
            result += buffer;
    }
    return result;
}

vector<string> get_domains_names(void)
{
    // get the output of ls command in a string
    string domains_name_result_of_ls_command = exec_command_and_return_result("ls named_dev");
    // change from string to stringstream to easy split it with newline
    stringstream domains_name_from_string_to_stream(domains_name_result_of_ls_command);
    vector<string> domains;
    string one_domain;
    // store domains name in domains array
    while (getline(domains_name_from_string_to_stream, one_domain, '\n'))
        // substr from 0 to length of string -3 to remove .db part
        domains.push_back(one_domain.substr(0, one_domain.length() - 3));
        
    return domains;
}