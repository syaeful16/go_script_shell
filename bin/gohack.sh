#!/bin/zsh

TEXT_RED="\033[31m"
TEXT_GREEN="\033[32m"
TEXT_WHITE="\033[97m"
TEXT_BLUE="\033[34m"

TEXT_BOLD="\033[1m"

BG_RED="\033[41m"
BG_GREEN="\033[42m"
BG_YELLOW="\033[43m"
BG_ORANGE="\033[48;5;208m\033[38;5;15m"

RESET="\033[0m"

if [ $# -eq 0 ]; then
	echo "${BG_RED} Error ${RESET} Argument is empty"
fi

command_support=("model" "controller" "helper")

if [ -n "$1" ] && [ -z "$2" ]; then
	if [ -z "$2" ]; then
		echo "${BG_RED} Error ${RESET} The inputted argument is incorrect\n"
		exit -1
	fi

	if [ "$1" == "starter-project" ]; then
		echo "${TEXT_BOLD}Starting make standar project...${RESET}\n"
		for folder in "${command_support[@]}"; do
			if [ -d "${folder}s" ]; then
				echo "${BG_ORANGE} Warning ${RESET} Folder ${TEXT_BOLD}${TEXT_BLUE}${folder}s${RESET} has been added\n"
			else 
				mkdir -p "${folder}s"
				if [ -d "${folder}s" ]; then
					echo "${BG_GREEN} Successfully ${RESET} Creating folder ${TEXT_BOLD}${TEXT_BLUE}${folder}s${RESET}\n"
				else
					echo "${BG_RED} Error ${RESET} Creating folder ${folder}s\n"
					exit -1
				fi
			fi
		done

		main_file="main.go"
		if [ -f "$main_file" ]; then
			echo "${BG_ORANGE} Warning ${RESET} file ${TEXT_BOLD}${TEXT_BLUE}${main_file}${RESET} has been added\n"
		else 
			content='package main \n\nfunc main() {\n\t// Tulis kode Anda di sini\n}'

			echo "$content" > "$main_file" 
			touch "$main_file"
			if [ -f "$main_file" ]; then
				echo "${BG_GREEN} Successfully ${RESET} Creating file ${TEXT_BOLD}${TEXT_BLUE}${main_file}${RESET}\n"
			else 
				echo "${BG_RED} Error ${RESET} Creating file ${main_file}\n"
				exit -1
			fi
		fi

		echo "Starter has been generated\n"
	else 
		echo "${BG_RED} Error ${RESET} The inputted argument is incorrect"
		exit -1
	fi
elif [ -n "$1" ] && [ -n "$2" ]; then
	fungsi="$1"
	command="$2"

	if [ "$fungsi" == "make" ] && [ -n $command ]; then
		IFS=':' read -r type filename <<< "$command"

		running_command=false
		for c_support in "${command_support[@]}"; do
			if [ "$type" == "$c_support" ]; then
				running_command=true
				type_command="$type"
				break
			fi
		done

		if [ "$running_command" == true ]; then
			# Checking folder is create or not
			if [ ! -d "${type}s" ]; then
				mkdir "${type}s"
				echo "\n${BG_GREEN} Successfully ${RESET} Creating folder ${TEXT_BOLD}${TEXT_BLUE}${type}s${RESET}\n"
			fi

			# Fill content code
			if [ "$type" == "controller" ]; then
				text_lowercase=$(echo "$filename" | tr '[:upper:]' '[:lower:]')
				# Create path controller
				create_new_folder_controller="${type}s/$text_lowercase"
				# Check is create folder or no
				if [ -d "$create_new_folder_controller" ]; then
					echo "\n${BG_ORANGE} Warning ${RESET} Folder ${TEXT_BOLD}${TEXT_BLUE}${create_new_folder_controller}${RESET} has been added"
				else 
					# Create folder controller
					mkdir -p "$create_new_folder_controller"
					# Check success create folder
					if [ -d "$create_new_folder_controller" ]; then
						echo "\n${BG_GREEN} Successfully ${RESET} Creating folder ${TEXT_BOLD}${TEXT_BLUE}${create_new_folder_controller}${RESET}"
					else 
						echo "\n${BG_GREEN} Error ${RESET} Failed create folder ${create_new_folder_controller}"
						exit -1
					fi
				fi


				# Definde path file to create
				create_new_file_controller="${create_new_folder_controller}/${filename}.go"
				# Check file is added or no
				if [ -f "$create_new_file_controller" ]; then
					echo "\n${BG_ORANGE} Warning ${RESET} File ${TEXT_BOLD}${TEXT_BLUE}${create_new_file_controller}${RESET} has been added"
				else 
					# Content for add to file controller
					content_default_code="package ${text_lowercase}\n\nimport \"net/http\"\n\nfunc Index(w http.ResponseWriter, r *http.Request) {\n\n}\n\nfunc Show(w http.ResponseWriter, r *http.Request) {\n\n}\n\nfunc Create(w http.ResponseWriter, r *http.Request) {\n\n}\n\nfunc Update(w http.ResponseWriter, r *http.Request) {\n\n}\n\nfunc Delete(w http.ResponseWriter, r *http.Request) {\n\n}"
					# Fill content to file controller
					echo "$content_default_code" > "$create_new_file_controller"
					# Create file controller
					touch "$create_new_file_controller"
					if [ -f "$create_new_file_controller" ]; then
						echo "\n${BG_GREEN} Successfully ${RESET} Creating file in ${TEXT_BOLD}${TEXT_BLUE}${create_new_file_controller}${RESET}"
					else 
						echo "\n${BG_ERROR} Error ${RESET} Failed creating file in ${create_new_file_controller}"
						exit -1
					fi
				fi
			elif [ "$type" == "model" ] || [ "$type" == "helper" ]; then
				# Checking folder is added or not
				if [ ! -d "${type}s" ]; then
					mkdir "${type}s"
					echo "\n${BG_GREEN} Successfully ${RESET} Creating folder ${TEXT_BOLD}${TEXT_BLUE}${type}s${RESET}\n"
				fi

				# Define path file
				create_new_file_model="${type}s/${filename}.go"
				# Check file has been added or no
				if [ -f "$create_new_file_model" ]; then
					echo "\n${BG_ORANGE} Warning ${RESET} File ${TEXT_BOLD}${TEXT_BLUE}${create_new_file_model}${RESET} has been added"
				else 
					# Make capitalized name model
					model_filename_capitalized=$(echo "$filename" | awk '{print toupper(substr($0,1,1))substr($0,2)}')
					content_file_model=""
					# Create content model
					if [ "$type" == "model" ]; then
						content_file_model="package ${type}s\n\ntype ${model_filename_capitalized}s struct {\n\tID\tstring\t\`gorm:\"primaryKey\" json:\"id\"\`\n}"
					else 
						content_file_model="package ${type}s\n\nfunc ${model_filename_capitalized}() {\n\n}"
					fi 
					# Fill content to file model
					echo "$content_file_model" > "$create_new_file_model"
					# Create file model
					touch "$create_new_file_model"

					# Check file has been created
					if [ -f "$create_new_file_model" ]; then
						echo "\n${BG_GREEN} Successfully ${RESET} Creating file in ${TEXT_BOLD}${TEXT_BLUE}${create_new_file_model}${RESET}"
					else 
						echo "\n${BG_ERROR} Error ${RESET} Failed creating file in ${create_new_file_controller}"
						exit -1
					fi
				fi
			fi
		else 
			echo "\n${BG_RED} Error ${RESET} Argument is incorrect\n"
			exit -1
		fi
	else
		echo "${BG_RED} Error ${RESET} The inputted argument is incorrect"
	fi
fi