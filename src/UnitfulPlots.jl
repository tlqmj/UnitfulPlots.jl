module UnitfulPlots
using Unitful
importall RecipesBase

function unit_formatter(T, num)
    string(num)*" "*string(unit(zero(T)))
end

function handle_attributes!(d::Dict{Symbol, Any}, axis, T::Type)
    if haskey(d, Symbol(axis, :guide))
        d[Symbol(axis, :guide)] *= " ("*string(unit(zero(T)))*")"
    elseif !haskey(d, Symbol(axis, :formatter))
        d[Symbol(axis, :formatter)] = x->unit_formatter(T,x)
    end
end

# 2D plots (1 recipe for shorthand form)
@recipe function f(val::AbstractVector{T}, args...) where {T<:Quantity}
    handle_attributes!(plotattributes, :y, T)
    tuple(ustrip.(val), args...)
end


# 2D plots (2^4-1 user recipes)
@recipe function f(val::AbstractVector{S}, val2::AbstractVector{T}, args...) where {S<:Quantity, T<:Quantity}
    handle_attributes!(plotattributes, :x, S)
    handle_attributes!(plotattributes, :y, T)
    tuple(ustrip.(val), ustrip.(val2), args...)
end

@recipe function f(val::AbstractVector{S}, val2::AbstractVector{T}, args...) where {S<:Number, T<:Quantity}
    handle_attributes!(plotattributes, :y, T)
    tuple(val, ustrip.(val2), args...)
end

@recipe function f(val::AbstractVector{S}, val2::AbstractVector{T}, args...) where {S<:Quantity, T<:Number}
    handle_attributes!(plotattributes, :x, S)
    tuple(ustrip.(val), val2, args...)
end

# 3D plots (2^8-1 user recipes)
@recipe function f(
    val::AbstractVector{S}, val2::AbstractVector{T}, val3::AbstractMatrix{U}, args...) where {S<:Quantity, T<:Quantity, U<:Quantity}
    handle_attributes!(plotattributes, :x, S)
    handle_attributes!(plotattributes, :y, T)
    handle_attributes!(plotattributes, :z, U)
    tuple(ustrip.(val), ustrip.(val2), ustrip.(val3), args...)
end

@recipe function f(
    val::AbstractVector{S}, val2::AbstractVector{T}, val3::AbstractMatrix{U}, args...) where {S<:Quantity, T<:Quantity, U<:Number}
    handle_attributes!(plotattributes, :x, S)
    handle_attributes!(plotattributes, :y, T)
    tuple(ustrip.(val), ustrip.(val2), val3, args...)
end

@recipe function f(
    val::AbstractVector{S}, val2::AbstractVector{T}, val3::AbstractMatrix{U}, args...) where {S<:Quantity, T<:Number, U<:Quantity}
    handle_attributes!(plotattributes, :x, S)
    handle_attributes!(plotattributes, :z, U)
    tuple(ustrip.(val), val2, ustrip.(val3), args...)
end

@recipe function f(
    val::AbstractVector{S}, val2::AbstractVector{T}, val3::AbstractMatrix{U}, args...) where {S<:Number, T<:Quantity, U<:Quantity}
    handle_attributes!(plotattributes, :y, T)
    handle_attributes!(plotattributes, :z, U)
    tuple(val, ustrip.(val2), ustrip.(val3), args...)
end

@recipe function f(
    val::AbstractVector{S}, val2::AbstractVector{T}, val3::AbstractMatrix{U}, args...) where {S<:Quantity, T<:Number, U<:Number}
    handle_attributes!(plotattributes, :x, S)
    tuple(ustrip.(val), val2, val3, args...)
end

@recipe function f(
    val::AbstractVector{S}, val2::AbstractVector{T}, val3::AbstractMatrix{U}, args...) where {S<:Number, T<:Quantity, U<:Number}
    handle_attributes!(plotattributes, :y, T)
    tuple(val, ustrip.(val2), val3, args...)
end

@recipe function f(
    val::AbstractVector{S}, val2::AbstractVector{T}, val3::AbstractMatrix{U}) where {S<:Number, T<:Number, U<:Quantity}
    handle_attributes!(plotattributes, :z, U)
    tuple(val, val2, ustrip.(val3), args...)
end

end
