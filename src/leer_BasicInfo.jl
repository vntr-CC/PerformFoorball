using DataFrames, XLSX

# Definimos la estructura de BasicInfo
struct BasicInfo
    match_id::String
    basic_info::DataFrame
    team_id::String
    team_info::DataFrame
end

function leer_BasicInfo(path::String)
    # Leemos fichero
    xf = XLSX.readxlsx(path)
    sps_names = XLSX.sheetnames(xf)

    # Leemos primera hoja
    info_match = xf[sps_names[1]]
    # Convertimos a DataFrame
    df_info_match = DataFrame(info_match[:], :auto)
    # Eliminamos primera fila
    delete!(df_info_match, 1)
    # Reasignamos los nombres a las columnas
    df_info_match = rename(df_info_match, ["Basic Info", "Data"])
    # Obtenemos id del match
    match_id = df_info_match[2,2]

    # Leemos segunda hoja
    info_players = xf[sps_names[2]]
    # Convertimos a DataFrame
    df_info_players = DataFrame(info_players[:], :auto)
    # Guardamos los nombres de la primera fila
    column_names = Vector{String}(df_info_players[1, :])
    # Renombramos los nombres de las columnas
    df_info_players = rename(df_info_players, column_names)
    # Eliminamos primera fila
    delete!(df_info_players, 1)
    # Obtenemos id del equipo
    team_id = df_info_match[5, 2]

    # Devolvemos la informacion pertinente
    BasicInfo(match_id, df_info_match, team_id, df_info_players)

end
