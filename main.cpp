#include "Domain.hpp"

int main(void)
{
    try {
        sql::Driver *driver;
        sql::Connection *con;
        sql::Statement *stmt;
        // sql::ResultSet *res;
        vector<Domain> domains;

        // /* Create a connection */
        // driver = get_driver_instance();
        // con = driver->connect("tcp://127.0.0.1:3306", "root", "toor");
        // /* Connect to the MySQL domains database */
        // con->setSchema("domains");
        // stmt = con->createStatement();
        // domains = get_domains_names();
        // for (auto domain: domains)
        //     stmt->execute("INSERT INTO domains(name) VALUES('" + domain + "')");

        domains = Domain::get_domains_names();
        for (int i = 0;i < domains.size();i++)
        {
            domains[i].get_info_from_whois_query();
            domains[i].display_domain_info();
            // break;
        }

        // delete res;
        // delete stmt;
        // delete con;
    }
    catch (sql::SQLException &e) {
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line  » "<< __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
    }

    cout << endl;

    return EXIT_SUCCESS;
}

// -l mysqlcppconn