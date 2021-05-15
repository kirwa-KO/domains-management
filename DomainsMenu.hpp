#ifndef DOMAINSMENU_HPP
#define DOMAINSMENU_HPP
#include "Domain.hpp"

class DomainsMenu
{
    private:
        // Menu Window
        WINDOW  *       win;
        // Domain details info window
        WINDOW  *       popup;
        int             xMax;
        int             yMax;
        int             stdscr_xMax;
        int             stdscr_yMax;
        int             highlight;
        int             xBeg;
        int             yBeg;
        int             width;
        int             height;
        int             x;
        int             y;
        int             start;
        int             domains_size;
        vector<Domain>  domains;
    public:
        DomainsMenu(int height, int width, int y, int x, vector<Domain> domains);
        // getters
        WINDOW * get_win(void);
        int get_xMax(void);
        int get_yMax(void);
        int get_highlight(void);
        int get_xBeg(void);
        int get_yBeg(void);
        int get_width(void);
        int get_height(void);
        int get_x(void);
        int get_y(void);
        int get_start(void);
        // setters
        void set_highlight(int highlight);
        void set_start(int start);
        void set_stdscr_xMax(int stdscr_xMax);
        void set_stdscr_yMax(int stdscr_yMax);
        // other function
        void    erase();
        void    refresh();
        void    draw();
        void    press_up_arrow();
        void    press_down_arrow();
        void    press_left_arrow();
        void    press_right_arrow();
        void    press_enter();
        void    press_esc();
        bool    get_pressed_key(int select_domain);
        ~DomainsMenu();
};

#endif