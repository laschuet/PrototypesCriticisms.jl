using PrototypesCriticisms
using Documenter

DocMeta.setdocmeta!(
    PrototypesCriticisms,
    :DocTestSetup,
    :(using PrototypesCriticisms);
    recursive=true,
)

makedocs(;
    modules=[PrototypesCriticisms],
    authors="Lars Schütz",
    sitename="PrototypesCriticisms.jl",
    doctest=false,
    format=Documenter.HTML(; edit_link="main", assets=String[]),
    pages=["Welcome" => "index.md"],
)

doctest(PrototypesCriticisms)

deploydocs(; repo="github.com/laschuet/PrototypesCriticisms.jl", devbranch="main")
