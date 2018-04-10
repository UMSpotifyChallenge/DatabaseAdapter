attrs = ["id", "acousticness", "danceability", "duration", "energy", "instrumentalness", "key", "liveness", "loudness", "mode", "speechiness", "tempo", "time_signature", "valence"];
A = csvread('track_features_1000.csv', 1, 0);
for i = 2:14
    attr = attrs(i);
    t = A(:, i);
    histogram(t, 1000);
    xlabel(attr);
    print(attr,'-dpng');
end
