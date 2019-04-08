module CIFAR100

import ..Datasets.unpack

function getdata(dir::String)
    mkpath(dir)
    url = "https://www.cs.toronto.edu/~kriz/cifar-100-binary.tar.gz"
    println("Downloading $url...")
    path = download(url)
    run(unpack(path,dir,".gz",".tar"))
end

function readdata(data::Vector{UInt8})
    n = Int(length(data)/3074)
    x = Matrix{Float64}(3072, n)
    y = Matrix{Int}(2, n)
    for i = 1:n
        k = (i-1) * 3074 + 1
        y[:,i] = data[k:k+1]
        x[:,i] = data[k+2:k+3073] / 255
    end
    x = reshape(x, 32, 32, 3, n)
    x, y
end

function traindata(dir::String)
    file = joinpath(dir, "cifar-100-binary","train.bin")
    isfile(file) || getdata(dir)
    readdata(open(read,file))
end

function testdata(dir::String)
    file = joinpath(dir, "cifar-100-binary","test.bin")
    isfile(file) || getdata(dir)
    readdata(open(read,file))
end

end
