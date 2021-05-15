#include "Domain.hpp"

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
	
// trim from end of string (right)
string& rtrim(string& s, const char* t)
{
	s.erase(s.find_last_not_of(t) + 1);
	return s;
}

// trim from beginning of string (left)
string& ltrim(string& s, const char* t)
{
	s.erase(0, s.find_first_not_of(t));
	return s;
}

// trim from both ends of string (right then left)
string& trim(string& s, const char* t)
{
	return ltrim(rtrim(s, t), t);
}

void    draw_bottom_bar_menu(WINDOW * bottom_menu_bar, int yMax, int xMax)
{
    // bottom menu bar intialisation
    bottom_menu_bar = newwin(5, 65, yMax - 6, (xMax - 65) / 2);
    // print key that can use in domains menu
    mvwprintw(bottom_menu_bar, 1, 1, "|UP|   => Prev      |DOWN|  => Next      |Q/q|   => Quit");
    mvwprintw(bottom_menu_bar, 2, 1, "|E/e|  => Edit      |D/d|   => Delete    |ENTER| => All");
    mvwprintw(bottom_menu_bar, 3, 1, "|LEFT| => Prev Side |RIGHT| => Next Side |ESC|   => Close POPUP");
    // print bottom menu box
    box(bottom_menu_bar, 0, 0);
    refresh();
    wrefresh(bottom_menu_bar);
}