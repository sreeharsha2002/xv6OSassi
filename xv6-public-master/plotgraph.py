import matplotlib.pyplot as pt
f1=open("./times.txt",'r')
f2=open("./timescopy.txt",'w+')
i=0
s=[]
for each in f1:
    if each[0].isdigit() :
        i=i+1
        s.append(each)

s[i-1]=s[i-1].strip("\n")
for l in range(i):
    f2.write(s[l])
f1.close()
f2.close()


with open("./timescopy.txt") as target:
    given=map(lambda x: [int(x[0]),int(x[1]),int(x[2])],map(lambda x : x.split(" "),target.read().split("\n")))
points=list(given)
noofproc=5
noofproc=noofproc+4
startingindex=4
pt.yticks([0,1,2,3,4])
pt.xlabel("Ticks")
pt.ylabel("QueueId")
for proc in range (startingindex,noofproc):
    px=[]
    py=[]
    for line in points:
        if(line[1]==proc):
            px.append(line[0])
            py.append(line[2])
    pt.plot(px,py, linestyle='--',marker='o',label=str(proc))
pt.legend()
pt.show()