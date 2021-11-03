function P(...)
    local objects = vim.tbl_map(vim.inspect, {...})
    print(unpack(objects))
    return ...
end

RELOAD = function(...)
  return require("plenary.reload").reload_module(...)
end

R = function(name, opts)
    opts = opts or {}
    RELOAD(name)
    if opts.setup then
        return require(name).setup(opts.setup)
    end

    return require(name)
end
