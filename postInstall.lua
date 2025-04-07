#!/usr/bin/env lua

-- Author: 919msda  
-- Title: postInstall  
-- Requ.: Lua5.3	    
-- 
--[==[==================================================================================]==]--
--[==[                                                                                  ]==]--
--[==[    /$$$$$$    /$$    /$$$$$$                                /$$                  ]==]--
--[==[   /$$__  $$ /$$$$   /$$__  $$                              | $$                  ]==]--
--[==[   | $$  \ $$|_  $$  | $$  \ $$ /$$$$$$/$$$$   /$$$$$$$  /$$$$$$$  /$$$$$$        ]==]--
--[==[   |  $$$$$$$  | $$  |  $$$$$$$| $$_  $$_  $$ /$$_____/ /$$__  $$ |____  $$       ]==]--
--[==[    \____  $$  | $$   \____  $$| $$ \ $$ \ $$|  $$$$$$ | $$  | $$  /$$$$$$$       ]==]--
--[==[      /$$  \ $$  | $$   /$$  \ $$| $$ | $$ | $$ \____  $$| $$  | $$ /$$__  $$     ]==]--
--[==[     |  $$$$$$/ /$$$$$$|  $$$$$$/| $$ | $$ | $$ /$$$$$$$/|  $$$$$$$|  $$$$$$$     ]==]--
--[==[      \______/ |______/ \______/ |__/ |__/ |__/|_______/  \_______/ \_______/     ]==]--
--[==[                                                                                  ]==]--
--[==[==================================================================================]==]--                                                                        




---------------- DEBUT FILE_EXISTS ----------------
local function file_exists(filename)
    local file = io.open(filename, "r")
    local exists = false

    if file then
	    io.close(file)
	    exists = true
    end
    return exists
end
--file_exists(filename)
---------------- FIN FILE_EXISTS ----------------




---------------- DEBUT LOGS ----------------
--logs(log)
local function logs(log)
    local file
    local date_heure = os.date("[%Y-%m-%d] %H:%M:%S ")
    local USER = os.getenv("USER")
    local HOME = os.getenv("HOME")

    -- Si fichier log existe, ajoute a la suite du fichier
    if file_exists(HOME .. "/postInstall_Lua.log") then
        file = io.open(HOME .. "/postInstall_Lua.log", "a")
    else
    -- Si fichier log n'existe pas, cree le fichier
        file = io.open(HOME .. "/postInstall_Lua.log", "w")
    end
    -- format: '[YYYY-mm-dd] HH:MM:SS as USER log'
    file:write(date_heure .. "as " .. USER .. " " ..  log)
    file:close()
end
--logs(log)
---------------- FIN LOGS ----------------




---------------- DEBUT START_BACKUP ----------------
local function start_backup()
    local cmd = "sudo cp "
    local sls = "/etc/apt/sources.list.scytale"
    local sli = "/etc/apt/sources.list.internet"
    local hostn = "/etc/hostname"
    local hosts = "/etc/hosts"

    local OK = ".orig: /OK/\n"
    local CREATED = ".orig: /CREATED/\n"

    -- BACKUP /etc/apt/sources.list.scytale
    if not file_exists(sls .. ".orig") then
        os.execute(cmd .. sls .. " " .. sls .. ".orig")
        logs(sls .. CREATED)
    else
        logs(sls .. OK)
    end

    -- BACKUP /etc/apt/sources.list.internet
    if not file_exists(sli .. ".orig") then
        os.execute(cmd .. sli .. " " .. sli .. ".orig")
        logs(sli .. CREATED)
    else
        logs(sli .. OK)
    end
    
    -- BACKUP /etc/hostname
    if not file_exists(hostn .. ".orig") then
        os.execute(cmd .. hostn .. " " .. hostn .. ".orig")
        logs(hostn .. CREATED)
    else
        logs(hostn .. OK)
    end
    
    -- BACKUP /etc/hosts
    if not file_exists(hosts .. ".orig") then
        os.execute(cmd .. hosts .. " " .. hosts .. ".orig")
        logs(hosts .. CREATED)
    else
        logs(hosts .. OK)
    end
    io.write("\n\nSTART_BACKUP(): /OK/\n")
end
--start_backup()
---------------- FIN START_BACKUP ----------------




---------------- DEBUT AIDE & ERREUR ----------------
--afficher_aide()
local function afficher_aide()
    io.write("\nUsage: lua " .. arg[0])
    os.exit(0)
end
--afficher_aide()

--afficher_erreur(e)
local function afficher_erreur(e)
    io.stderr:write("\nErreur: " .. tostring(e))
    os.exit(1)
end
--afficher_erreur(e)
---------------- FIN AIDE & ERREUR ----------------




-- Blindage des arguments
if #arg ~= 0 then
    afficher_aide()
end




---------------- DEBUT VERIF INTERNET ----------------
--local success = os.execute("ping google.com -c 3 > /dev/null 2>&1")

--if not success then
--    afficher_erreur("Vous devez avoir acces a internet pour ce programme.")
--end
---------------- FIN VERIF INTERNET ----------------




---------------- DEBUT VERIF USER ----------------
user = os.getenv("USER")

if user ~= "installateur" then
    afficher_erreur("Vous devez etre en 'installateur' pour executer ce code.")
end
---------------- FIN VERIF USER ----------------




---------------- DEBUT PAQUETS ----------------
local paquets_i3 = {
    [1] = "i3-wm",
    [2] = "i3lock",
    [3] = "xorg",
    [4] = "lxappearance",
    [5] = "materia-gtk-theme",
    [6] = "papirus-icon-theme",
    [7] = "fonts-font-awesome",
    [8] = "rofi",
    [9] = "polybar",
    [10] = "kitty",
    [11] = "neofetch",
    [12] = "lightdm",
    [13] = "lightdm-gtk-greeter",
}

local paquets_cours_C = {"doxygen", "doxygen-gui", "graphviz"}
--local paquets_cours_ = {}
---------------- FIN PAQUETS ----------------






----------------------- DEBUT MAJ PAQUETS --------------------------------]
-- mise_a_jour_paquets()						--]
local function mise_a_jour_paquets()					--]
    print("Mise a jour des paquets...\n\n")				--]
									--]
    if os.execute("sudo apt update -y") then				--]
	print("--- Mise a jour teminee sans probleme ---")		--]
    else
        afficher_erreur("Echec de la mise a jour des paquets...")
    end	
end	
--mise_a_jour_paquets()	
----------------------- FIN MAJ PAQUETS ----------------------------------]






----------------------- DEBUT INSTALL PAQUETS --------------------]
-- installer_paquets()						--]
local function installer_paquet(paquet_a_installer)
    os.execute("sudo apt install " .. paquet_a_installer .. " -y")
end

local function installer_paquets()
    io.write("\n--- LISTE DES PAQUETS ---")
    for i,val in ipairs(paquets) do
	    io.write("\n- " .. tostring(val))
    end

    io.write("\n\nInstallation totale ou selective ?\n")
    io.write("T/s: ")
    local full = io.read()

    local ans
    for i, val in ipairs(paquets) do

	    if full:match("^[Tt]$") or full == "" then
	        installer_paquet(val)

	    elseif full:match("^[Ss]$") then
	        io.write("\n\nVoulez-vous installer: " .. tostring(val) .. "?\n")
	        io.write("Y/n: ")
	        ans = io.read()

	
	        if ans:match("^[Yy]$") or ans == "" then
	            installer_paquet(val)
	        end
	    else
	        afficher_erreur("Veuillez entrer une reponse valable...")
	    end
    end
end
--installer_paquets()
----------------------- FIN INSTALL PAQUETS ----------------------]




---------------- DEBUT HOSTNAME ----------------
--hostname()
local function hostname()
    io.write("Entrez votre numero de poste type scyTale:\nVotre sc000000: ")
    local numSC
    local valid_input = false

    repeat
	    numSC = io.read()
        if string.match(numSC, "sc%d%d%d%d%d%d") then
            os.execute("echo \"" .. numSC .. "\" > ~/hostname")

	        io.write("OK : " .. numSC .. "\n")
	        valid_input = true
            logs("numSC: " .. numSC .. " /OK/")
        else
	        io.write("Le format ne respecte pas: sc000000\n")
            logs("numSC" .. numSC .. " /NOK/\n")
	end
    until valid_input

    if file_exists("~/hostname") then
	    os.execute("sudo mv ~/hostname /etc/")
    end

    os.execute("sudo sed -i 's/localhost$/localhost " .. numSC .. "/g' /etc/hosts")
    io.write("\n\nhostname() : OK")
end
-- hostname()
---------------- FIN HOSTNAME ----------------




---------------- DEBUT LISTE_FONCTIONS ----------------
--liste_fontions()
local liste_choix = {
    "Backup des fichiers sources.list, hostname, hosts",
    "Changer hostname",
    "Installer paquets",
    "Quitter"
}
local function liste_fonctions()
    for key, val in ipairs(liste_choix) do
	    io.write(key .. " - " .. val .. "\n")
	end
end
--liste_fonctions()
---------------- FIN LISTE_FONCTIONS ----------------





-- main()
local function main()
    local user_input
    local exit

    while exit ~= true do
	    io.write("--- BIENVENUE SUR CE PGRM POSTINSTALL LUA ---\n\n")
	    io.write("Voici les options disponibles :\n")
        liste_fonctions()
        io.write("\n--- Selectionnez le numero de votre choix ---\n")
        io.write("Choix : ")
        user_input = io.read("*n")

        if user_input == 1 then
            start_backup()

        elseif user_input == 2 then
            hostname()
        
        elseif user_input == 3 then
            mise_a_jour_paquets()
            installer_paquets()
        
        elseif user_input == 4 then
            exit = true
            io.write("\n\nVoir les logs: cat ~/postInstall_Lua.log")
        end
    end
end
main()
