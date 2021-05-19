#include "MenuAndContent.hpp"

sql::Statement *	g_stmt;

string				Domain::selected_domain_tld = "%";
int					Domain::selected_domain_size = 255;
vector<string>      Domain::registrar_names;

int main(void)
{
    try {
        sql::Driver *driver;
        sql::Connection *con;
        // sql::Statement *stmt = NULL;
        vector<Domain> domains;
        // vector<Domain> domains_from_database;
        int xMax, yMax, select_domain;
        char choice = '\0';
        bool    quit_loop = false;
        vector<Nservers> servers;

        // Create a connection
        driver = get_driver_instance();
        con = driver->connect("tcp://127.0.0.1:3306", "root", "toor");
        // Connect to the MySQL domains database
        con->setSchema("domains");
        // create statement to get and update data in database
        g_stmt = con->createStatement();
        g_stmt->execute("SET collation_connection = 'utf8_general_ci';");
        g_stmt->execute("ALTER DATABASE domains CHARACTER SET utf8 COLLATE utf8_general_ci;");
        g_stmt->execute("ALTER TABLE domains CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;");
        g_stmt->execute("ALTER TABLE registrar CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;");
        g_stmt->execute("ALTER TABLE nservers CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;");
    
        // check if the user want to add domains from directory
        // cout << BOLDYELLOW << "If you want to add domains to database press [y/Y] : " << RESET;
        // cin >> choice;
        // if (choice == 'y' OR choice == 'Y')
        // {
            // domains = Domain::get_domains_names_from_directory();
            // Domain::add_domains_to_database(domains);
            // servers = Nservers::get_nservers_info_from_config_file();
            // Nservers::put_nservers_info_in_database(servers);
        // }

        initscr();
        if(!has_colors())
        {
            cout << BOLDRED << "You Terminal Dont support ncurses colors" << RESET << endl;
            endwin();
            delete g_stmt;
            delete con;
            return (-1);
        }
        start_color();
        // make a color pair
        init_pair(1, COLOR_BLACK, COLOR_WHITE);

        getmaxyx(stdscr, yMax, xMax);
        // draw_numbers_in_screen_corners(yMax, xMax);
        MenuAndContent	menu_and_content(yMax - 2, xMax - 2, 0, 0);
        menu_and_content.set_stdscr_xMax(xMax);
        menu_and_content.set_stdscr_yMax(yMax);
        refresh();
        while (!quit_loop)
        {
            menu_and_content.draw();
            select_domain = wgetch(menu_and_content.get_win());
            quit_loop = menu_and_content.get_pressed_key(select_domain);
        }
        endwin();
        cout << BOLDGREEN << "Bye, And Thank you for using " << RESET << BOLDWHITE << "| ISMAEL |" << RESET << BOLDGREEN << " Tool.!!!" << RESET << endl;
        delete g_stmt;
        delete con;
    }
    catch (sql::SQLException &e) {
        endwin();
        cout << "# ERR: SQLException in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line  » "<< __LINE__ << endl;
        cout << "# ERR: " << e.what();
        cout << " (MySQL error code: " << e.getErrorCode();
        cout << ", SQLState: " << e.getSQLState() << " )" << endl;
        return EXIT_FAILURE;
    }
    catch (std::exception &e) {
        endwin();
        cout << "# ERR: in " << __FILE__;
        cout << "(" << __FUNCTION__ << ") on line  » "<< __LINE__ << endl;
        cout << "# ERR: " << e.what();
        return EXIT_FAILURE;
    }

    return EXIT_SUCCESS;
}