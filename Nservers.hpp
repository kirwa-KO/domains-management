#ifndef NSERVERS_HPP
#define NSERVERS_HPP
#include "domains_names.hpp"

class Nservers
{
private:
    int id;
    string host;
    string ip;
    string os;
    string usr;
    string pass;
    string status;
    double lping;

public:
    Nservers();
    Nservers(string host, string ip, string usr);
    // getters
    int get_id();
    string get_host();
    string get_ip();
    string get_os();
    string get_usr();
    string get_pass();
    string get_status();
    double get_lping();
    void    diplay_info();

    // setters
    void set_id(int id);
    void set_host(string host);
    void set_ip(string ip);
    void set_os(string os);
    void set_usr(string usr);
    void set_pass(string pass);
    void set_status(string status);
    void set_lping(double lping);

    // static class method
    static vector<Nservers> get_nservers_info_from_config_file();

    ~Nservers();
};

#endif
