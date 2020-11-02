import matplotlib.pyplot as pt
f1=open("./times.txt",'r')
f2=open("./timescopy.txt",'w+')
i=0
s=[]
# for each in f1:
#     if each[0].isdigit() :
#         i=i+1
#         s.append(each)
k=[]
flag=0
for each in f1:
    k=each.split(" ")
    flag=0
   # print(k)
    for klk in k:
        if klk.strip("\n").isdigit()== False:
            flag=1
    if flag==0 and each[0].isdigit() :
        i=i+1
        s.append(each)
print(i)
s[i-1]=s[i-1].strip("\n")
setting=set()
for pid in s:
    setting.add(pid.split(" ")[1])
for l in range(i):
    f2.write(s[l])
f1.close()
f2.close()
print(len(setting))

with open("./timescopy.txt") as target:
    given=map(lambda x: [int(x[0]),int(x[1]),int(x[2])],map(lambda x : x.split(" "),target.read().split("\n")))
points=list(given)
noofproc=len(setting)
# noofproc=noofproc+4
startingindex=4
pt.yticks([0,1,2,3,4])
pt.xlabel("Ticks")
pt.ylabel("QueueId")
for proc in range (startingindex,noofproc+1):
    px=[]
    py=[]
    for line in points:
        if(line[1]==proc):
            px.append(line[0])
            py.append(line[2])
    pt.plot(px,py, linestyle='--',marker='o',label=str(proc))
pt.legend()
pt.show()