COMPILER	= clang++

FLAGS		= -Wextra -Wall -Werror -fsanitize=address -g

SRCS			= 	get_domains_names.cpp		\
					main.cpp

NAME 		= domains

LIBRARY = -l mysqlcppconn

all: $(NAME)

$(NAME) : $(SRCS)
	@$(COMPILER) $(FLAGS) $(SRCS) $(LIBRARY) -o $(NAME)

clean:
	rm -rf $(NAME)

fclean: clean

re: fclean all

.PHONY: re all fclean clean