COMPILER	= clang++

# FLAGS		= -Wextra -Wall -Werror -fsanitize=address -g -fsanitize=safe-stack
FLAGS		= -fsanitize=address -g

SRCS		= 	main.cpp			\
				Domain.cpp			\
				helper.cpp			\
				DomainsMenu.cpp

NAME 		= domains

LIBRARY = -l mysqlcppconn -lncurses

all: $(NAME)

$(NAME) : $(SRCS)
	@$(COMPILER) $(FLAGS) $(SRCS) $(LIBRARY) -o $(NAME)

clean:
	@rm -rf $(NAME)

fclean: clean

re: fclean all

.PHONY: re all fclean clean