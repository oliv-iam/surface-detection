names = ["User1" "User2" "User3" "User4" "User5"];
activities = ["LocationA" "LocationB" "LocationC" "LocationD" "LocationE"];

for i = 4:5 % iterate over users
    for j = 1:5 % iterate over activities
        fprintf("%s, %s\n", names(i), activities(j));
        fsegment(names(i), activities(j), "Normal", 14);
    end
end
