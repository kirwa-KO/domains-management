#include "Domain.hpp"

string exec_whois_get_result(string domain)
{
	string command = "whois " + domain;
	return (exec_command_and_return_result(static_cast<const char *>(&(command[0]))));
}

int main()
{
	string result = exec_whois_get_result("accrounds.com"), line;
	stringstream ss(result);
	// string names_servers[4] = {"", "", "", ""};
  Domain  dm;
	// int     ns_index = 0, i;
	
	while (getline(ss, line, '\n'))
	{
		if (line.find(" ns") != string::npos OR line.find(" NS") != string::npos)
		{
			// transform(line.begin(), line.end(), line.begin(), ::tolower);
      // line = trim(line, " ");
      // for (i = 0;i < 4;i++)
      //   if (names_servers[i] == line)
      //     break ;
      // if (i  == 4)
			//   names_servers[ns_index++] = line;
      dm.set_name_server(line);
		}
		// else if(input.find("admin") != string::npos)
	}
  for (auto x : dm.get_names_servers())
    if (x != "")
      cout << "{=> " << x << " ||}" << endl;
	return (0);
}

// get name servers
// whois kirwako.com | grep -i "\ ns" | awk '{print $3}' | tr [:upper:] [:lower:] | sort | uniq
// get registrar
//whois accrounds.com | grep " Registrar:" | awk '{print $2 " " $3}'
// get url
// whois accrounds.com | grep -i " Registrar\ URL:" | awk '{print $3}'
// get whois
// whois accrounds.com | grep -i ' Registrar WHOIS Server:' | awk '{print $4}'
// get tech name
// whois accrounds.com | grep "Tech\ Name"  
// get admin name
// whois accrounds.com | grep "Admin\ Name:"