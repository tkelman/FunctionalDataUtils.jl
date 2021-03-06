export jetcolormap, asimagesc, blocksvisu, pad, image2array

function jetcolormap(n)
    step(m, i) = i>=m ? 1.0 : 0.0
    grad(m, i) = (i-m)/(n/4) * step(m, i)

    a = n/8
    f(m, i) = grad(m+3a, i) - grad(m+a, i) - grad(m-a, i) + grad(m-3a, i)

    r = zeros(3,n)
    r[1, :] = [f(3n/4, i) for i in 1:n]
    r[2, :] = [f(n/2, i) for i in 1:n]
    r[3, :] = [f(n/4, i) for i in 1:n]
    r
end

function asimagesc(a, norm = true)
    cm = jetcolormap(256)
    r = Array(Float32, size(a, 1), size(a, 2), 3)
    normf = norm ? norm01 : identity
    b = round(Int, normf(a)*255) .+ 1
    r[:,:,1] = cm[1, b[:]]
    r[:,:,2] = cm[2, b[:]]
    r[:,:,3] = cm[3, b[:]]
    r
end

function blocksvisu(a)
    n = len(a)
    typ = eltype(fst(a))
    padsize(a) = ceil(Int,a/4)
    a = @p map a reshape | unstack
    z = @p zeros typ padsize(size(fst(a),1)) size(fst(a),2)
    a = @p partsoflen a ceil(Int,sqrt(n)) | map riffle z | map col | map flatten
    z = @p zeros typ size(fst(a),1) padsize(size(fst(a),2))
    a[end] = @p pad a[end] siz(fst(a))
    @p riffle a z | row | flatten
end

function pad(a, siz, value = 0)
    r = value * onessiz(siz, eltype(a))
    if ndims(r) == 1
        r[1:length(a)] = a
    elseif ndims(r) == 2
        r[1:size(a,1),1:size(a,2)] = a
    elseif ndims(r) == 3
        r[1:size(a,1),1:size(a,2),1:size(a,3)] = a
    elseif ndims(r) == 4
        r[1:size(a,1),1:size(a,2),1:size(a,3),1:size(a,4)] = a
    elseif ndims(r) == 5
        r[1:size(a,1),1:size(a,2),1:size(a,3),1:size(a,4),1:size(a,5)] = a
    else
        error("ndims not supperted")
    end
    r
end

image2array(img) = @p map Any[:r,:g,:b] (i->map(y->y.(i), img.data)) | stack
