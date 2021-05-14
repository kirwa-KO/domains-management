#include "domains_names.h"

int main(void)
{
    // cout << __FUNCTION__ << endl;
    // cout << "Running 'SELECT 'Hello World!' » AS _message'..." << endl;

    try {
        sql::Driver *driver;
        sql::Connection *con;
        sql::Statement *stmt;
        // sql::ResultSet *res;
        vector<string> domains;


        // stmt = con->createStatement();
        // res = stmt->executeQuery("SELECT 'Hello World!' AS _message");
        // while (res->next()) {
        //     cout << "\t... MySQL replies: ";
        //     /* Access column data by alias or column name */
        //     cout << res->getString("_message") << endl;
        //     cout << "\t... MySQL says it again: ";
        //     /* Access column data by numeric offset, 1 is the first column */
        //     cout << res->getString(1) << endl;
        // }


        /* Create a connection */
        driver = get_driver_instance();
        con = driver->connect("tcp://127.0.0.1:3306", "root", "toor");
        /* Connect to the MySQL domains database */
        con->setSchema("domains");
        stmt = con->createStatement();
        // stmt->execute("CREATE DATABASE proton");
        stmt->execute("INSERT INTO domains(name) VALUES('sproton.com')");
        domains = get_domains_names();
        for (auto domain: domains)
            stmt->execute("INSERT INTO domains(name) VALUES('" + domain + "')");

        // delete res;
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

// -l mysqlcppconn