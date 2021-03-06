doc"""
    tanh(x::Var)

Hyperbolic tangent function.
"""
Base.tanh(x::Var) = Var(tanh(x.data), ∇tanh!, (x,))
Base.tanh(x::Array) = tanh.(x)
Base.tanh(x::CuArray) = CUDNN.tanh(x)
Base.tanh(x::Node) = Node(tanh, (x,))

function ∇tanh!(y::Var, x::Var)
    isnothing(x.grad) && return
    ∇tanh!(y.data, y.grad, x.data, x.grad)
end

function ∇tanh!(y::Array{T}, gy::Array{T}, x::Array{T}, gx::Array{T}) where T
    @inbounds for i = 1:length(gx)
        gx[i] += gy[i] * (T(1) - y[i] * y[i])
    end
end

∇tanh!(y::CuArray, gy::CuArray, x::CuArray, gx::CuArray) = CUDNN.∇tanh!(y, gy, x, gx)
