$env.PATH = (
    $env.PATH
    | split row (char esep)
    | prepend '/run/current-system/sw/bin/'
)
