--require "NTLuaTools"
--require "NTStruct"
require "NTViewController"
os.execute("echo $HOSTTYPE")
--local arch = os.outputof("echo $HOSTTYPE")
--print(arch)
viewController = NTViewController:init()
window = UIApplication:sharedApplication():keyWindow()
window:setRootViewController(viewController)