#include "MenuAndContent.hpp"

sql::Statement *	g_stmt;

// selected filter data of variabels in Domain class
string				Domain::selected_domain_tld = "";
int					Domain::selected_domain_size = 255;

// selected filter data of variabels in Registrar class
string				Registrar::selected_registrar_name = "";
int					Registrar::selected_registrar_size = 255;

// selected filter data of variabels in Person class
string				Person::selected_person_name = "";
int					Person::selected_person_size = 255;

// selected filter data of variabels in Nserver class
string				Nserver::selected_nserver_host = "";
int					Nserver::selected_nserver_size = 255;

// array of registrar of domain to not insert a registrar that already exist
vector<string>		Domain::registrar_names;
// the database name get it from .env file
string				g_database_name;
// the database user get it from .env file
string				g_database_user;
// the database passwod get it from .env file
string				g_database_password;
// the path of domains names files get it from .env file
string				g_path_of_domains_names_files;
// the path of config file for servers get it from .env file
string				g_path_of_config_file_for_servers;

int main(void)
{
	try {

		sql::Driver *driver;
		sql::Connection *con;
		// sql::Statement *stmt = NULL;
		// vector<Domain> domains;
		// vector<Domain> domains_from_database;
		int xMax, yMax, select_domain;
		char choice = '\0';
		bool	quit_loop = false;
		// vector<Nserver> servers;


		// get the configuration info from .env file
		get_configuration_info_from_dot_env_file("./.env");
		// Create a connection
		driver = get_driver_instance();
		con = driver->connect("tcp://127.0.0.1:3306", g_database_user, g_database_password);
		// Connect to the MySQL domains database
		con->setSchema(g_database_name);
		// create statement to get and update data in database
		g_stmt = con->createStatement();
		g_stmt->execute("SET collation_connection = 'utf8_general_ci';");
		g_stmt->execute("ALTER DATABASE " + g_database_name + " CHARACTER SET utf8 COLLATE utf8_general_ci;");
		g_stmt->execute("ALTER TABLE domains CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;");
		g_stmt->execute("ALTER TABLE registrar CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;");
		g_stmt->execute("ALTER TABLE person CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;");
		g_stmt->execute("ALTER TABLE nservers CONVERT TO CHARACTER SET utf8 COLLATE utf8_general_ci;");
		
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
		init_pair(2, COLOR_RED, COLOR_BLACK);

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
