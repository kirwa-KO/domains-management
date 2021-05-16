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

void	draw_numbers_in_screen_corners(int yMax, int xMax)
{
    int i = 0;
    int first_numbred_row = 1, second_numbred_row = 1;
    
    while (i < xMax)
    {
        mvprintw(1, i + 2, to_string(second_numbred_row).c_str());
        i +=  1;
        if(i % 10 == 0)
        {
            if(first_numbred_row >= 10)
                mvprintw(0, i, to_string(first_numbred_row).c_str());
            else
                mvprintw(0, i + 1, to_string(first_numbred_row).c_str());
            first_numbred_row += 1;
        }
        second_numbred_row = (second_numbred_row + 1) % 10;
    }
    i = 0;
    second_numbred_row = -1;
    while (i < yMax)
    {
        second_numbred_row += 1;
        if (second_numbred_row != 0 AND second_numbred_row % 10 == 0)
            mvprintw(i + 2, 0, to_string(second_numbred_row).c_str());
        else
            mvprintw(i + 2, 0, (" " + to_string(second_numbred_row % 10)).c_str());
        i += 1;
    }
}

string  put_string_in_center(string & str, int number_of_case, char to_fill)
{
    string  str_to_ret((number_of_case - str.length()) / 2, to_fill);

    str_to_ret += str;
    for (int i = str_to_ret.length();i < number_of_case;i++)
        str_to_ret += to_fill;
    return str_to_ret;
}