#include "Domain.hpp"

int main(void)
{
    try {
        sql::Driver *driver;
        sql::Connection *con;
        sql::Statement *stmt;
        vector<Domain> domains;
        vector<string> domains_names_from_database;

        /* Create a connection */
        driver = get_driver_instance();
        con = driver->connect("tcp://127.0.0.1:3306", "root", "toor");
        /* Connect to the MySQL domains database */
        con->setSchema("domains");
        stmt = con->createStatement();

        // domains = Domain::get_domains_names();
        // Domain::add_domains_to_database(domains, stmt);

        domains_names_from_database = Domain::get_domains_names_from_database(stmt);
        for (auto x : domains_names_from_database)
        {
            cout << x << endl;
        }

        delete stmt;
        delete con;
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

    // stringstream bottom_menu_label_stream = BOLDWHITE << "UP :" << RESET << "Prev Domain " << BOLDWHITE << "DOWN:" << RESET << " Next Domain " << BOLDWHITE << "E/e:" << RESET << "Edit Domain " << BOLDWHITE << "D/d:Delete" << RESET << " Domain";
    // mvwprintw(bottom_menu_bar, 1, 1, bottom_menu_label_stream.str().c_str());