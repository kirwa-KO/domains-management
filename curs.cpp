#include "domains_names.h"
#include <ncurses.h>

int main()
{
    // string result = exec_whois_get_result("accrounds.com"), input;
    // stringstream ss(result);
    
    // while (getline(ss, input, '\n'))
    // {
    //     if (input.find(" ns") != string::npos OR input.find(" NS") != string::npos)
    //         cout << "ns: { " << input << " }" << endl;
    //     // else if(input.find("admin") != string::npos)
    // }

    initscr();
    // cbreak();
    noecho();
    raw();
    // keypad(stdscr, TRUE);
    WINDOW  *win = newwin(10, 50, 5, 5);
    refresh();
    // box(win, 0, 0);
    // move(4, 4);

    if(!has_colors())
    {
        printw("Terminal doesnt support color");
        getch();
        return -1;
    }
    start_color();

    init_pair(1, COLOR_WHITE, COLOR_RED);

    // attron(A_REVERSE);
    attron(COLOR_PAIR(1));
    printw("Hello screen..!!!");
    // attroff(A_REVERSE);
    attroff(COLOR_PAIR(1));
    // wprintw(win, "Hello win..!!!");
    int x, y;
    // getyx(win, y, x);
    // getbegyx(win, y, x);
    getmaxyx(stdscr, y, x);
    // wprintw(win, "%d %d", y, x);

    wrefresh(win);
    // int c  = getch();
    // move(0, 0);
    // printw("%d", c);
    // getch();
    WINDOW * input_win = newwin(3, x - 12, y - 5, 5);
    box(input_win, 0, 0);
    refresh();
    wrefresh(input_win);

    keypad(input_win, TRUE);
    int c = wgetch(input_win);
    if (c == KEY_UP)
    {
        mvwprintw(input_win, 1, 1, "You Press KEY UP");
        wrefresh(input_win);
    }
    getch();
    delwin(win);
    endwin();
    return 0;
}