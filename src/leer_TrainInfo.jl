using DataFrames, XLSX

# Definimos la estructura de TrainInfo
struct TrainInfo
    train_id::String
    train_info::DataFrame
    team_id::String
    train_team::DataFrame
    train_player::DataFrame
    train_physical::Vector{DataFrame}
    train_bpm::Vector{DataFrame}
end

function leer_TrainInfo(path::String)
    # Leemos fichero
    xf = XLSX.readxlsx(path)
    sps_names = XLSX.sheetnames(xf)

    # Leemos primera hoja
    info_match = xf[sps_names[1]]
    # Convertimos a DataFrame
    df_train = DataFrame(info_match[:], :auto)

    # Obtenemos la tabla de información del entrenamiento
    column_names_train = Vector{String}(df_train[1, :])
    df_train_info = df_train[1:2, :]
    rename!(df_train_info, column_names_train)
    delete!(df_train_info, 1)
    train_id = df_train_info[1, 1]

    # Obtenemos la tabla de información del team
    column_names_team = Vector{String}(df_train[5, 1:2])
    df_train_team = df_train[5:6, 1:2]
    rename!(df_train_team, column_names_team)
    delete!(df_train_team, 1)
    team_id = df_train_team[1, 1]

    # Obtenemos la tabla de información de los jugadores
    column_names_player = Vector{String}(df_train[9, 1:7])
    df_train_player = df_train[10:end, 1:7]
    rename!(df_train_player, column_names_player)

    ## Obtenemos las tablas de datos del entrenamiento
    # Datos físicos
    dfs_physical = Vector{DataFrame}()
    # Datos de los latidos por minuto
    dfs_bpm = Vector{DataFrame}()
    # Recorremos las hojas que contienen estas tablas
    for i in 2:length(sps_names)
        # Leemos la hoja i
        info_players = xf[sps_names[i]]
        df_players = DataFrame(info_players[:], :auto)

        # Al haber dos tablas divididas en la misma hoja de tamaño
        # variable, calculamos la división dependiendo de los
        # valores missing.
        player_id = df_players[2:end, 1]
        replace!(player_id, missing => 0)
        d = findfirst(x -> x == 0, player_id)

        # Obtenemos la tabla de los datos físicos
        column_names_physical = Vector{String}(df_players[1, :])
        df_train_physical = df_players[2:d, :]
        rename!(df_train_physical, column_names_physical)
        push!(dfs_physical, df_train_physical)

        # Obtenemos la tabla de los datos de latidos por minuto
        column_names_bpm = Vector{String}(player_id[1:d-1])
        df_train_bpm = df_players[d+5:end, 1:d-1]
        rename!(df_train_bpm, column_names_bpm)
        push!(dfs_bpm, df_train_bpm)
    end
    # Devolvemos la información pertienente
    TrainInfo(train_id, df_train_info, team_id, df_train_team, df_train_player, dfs_physical, dfs_bpm)
end
