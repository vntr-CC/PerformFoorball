using PerformFootball
using Test

@testset "Lectura de Datos Básicos" begin
    path = "../src/Data/Info_Basica/Orange Lions V20-2 vs Orange Lions V20-1/The data report of Orange Lions V20-120200122.xlsx"
    @test leer_BasicInfo(path).match_id == "38986AF3-4EC0-4EE0-AD8F-7569BB343ADC"
    @test size(leer_BasicInfo(path).basic_info) == (8, 2)
    @test leer_BasicInfo(path).team_id == "4967"
    @test size(leer_BasicInfo(path).team_info) == (5, 53)
end

@testset "Lectura de Datos de Entrenamiento" begin
    path = "../src/Data/Info_Entrenamiento/Orange Lions V20-1/58D7EBEB71C74AAB897D20493B15D912.xlsx"
    @test leer_TrainInfo(path).train_id == "58D7EBEB71C74AAB897D20493B15D912"
    @test leer_TrainInfo(path).team_id == "4967"
    @test length(leer_TrainInfo(path).train_physical) == 4
    @test length(leer_TrainInfo(path).train_bpm) == 4
end
