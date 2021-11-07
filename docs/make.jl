using Documenter, PerformFootball

makedocs(
    modules = [PerformFootball],
    format = Documenter.HTML(; prettyurls = get(ENV, "CI", nothing) == "true"),
    authors = "“Ventura Lastrucci”",
    sitename = "PerformFootball.jl",
    pages = Any["index.md"]
    # strict = true,
    # clean = true,
    # checkdocs = :exports,
)

deploydocs(
    repo = "github.com/vntr-CC/PerformFootball.jl.git",
    push_preview = true
)
