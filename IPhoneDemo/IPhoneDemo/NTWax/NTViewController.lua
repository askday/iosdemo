waxClass{"NTViewController", UIViewController}


function viewDidLoad(self)
self.super:viewDidLoad(self)

self:view():setBackgroundColor(UIColor:redColor())
local rect = CGRect(100, 220, 320, 40)
print(rect.x)
local label = UILabel:initWithFrame(rect)
label:setColor(UIColor:blackColor())
label:setText("Hello Wax!")
label:setTextAlignment(UITextAlignmentCenter)
local font = UIFont:fontWithName_size("Helvetica-Bold",50)
label:setFont(font)

self:view():addSubview(label)
end


function btnTestClick(self)
    print("lua click called");
    self:doSomeThing()
end