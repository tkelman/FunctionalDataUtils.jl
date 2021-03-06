module FunctionalDataUtils
using Reexport
@reexport using FunctionalData
using Compat, SHA
import FactCheck

include("computing.jl")
include("numerical.jl")
include("computervision.jl")
include("fmIO.jl")
include("graphics.jl")
include("machinelearning.jl")
# include("matlab.jl")
include("numerical.jl")
include("output.jl")
include("utils.jl")
include("system.jl")
include("sampler.jl")

end # module
