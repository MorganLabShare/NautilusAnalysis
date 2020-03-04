function connections = FinalCNNctAnalysis 
% ..Number of axons
    Naxon = 143;
% ..Pre-allocate connection array
    connections = zeros(Naxon, 3);

% ..Initialize the array row by row
    connections(:,1) = [ ...
                2, ... 0
                0, ... 1
                0, ... 2
                0, ... 3
                0, ... 4
                0, ... 5
                0, ... 6
                0, ... 7
                0, ... 8
                0, ... 9
                0, ... 10
                0, ... 11
                0, ... 12
                0, ... 13
                0, ... 14
                0, ... 15
                0, ... 16
                0, ... 17
                0, ... 18
                0, ... 19
                0, ... 20
                0, ... 21
                0, ... 22
                0, ... 23
                0, ... 24
                0, ... 25
                0, ... 26
                0, ... 27
                0, ... 28
                0, ... 29
                0, ... 30
                0, ... 31
                0, ... 32
                0, ... 33
                1, ... 34
                0, ... 35
                0, ... 36
                0, ... 37
                0, ... 38
                0, ... 39
                1, ... 40
                0, ... 41
                0, ... 42
                1, ... 43
                0, ... 44
                0, ... 45
                2, ... 46
                2, ... 47
                1, ... 48
                1, ... 49
                1, ... 50
                1, ... 51
                2, ... 52
                1, ... 53
                2, ... 54
                1, ... 55
                3, ... 56
                2, ... 57
                1, ... 58
                1, ... 59
                2, ... 60
                1, ... 61
                2, ... 62
                1, ... 63
                1, ... 64
                1, ... 65
                3, ... 66
                1, ... 67
                1, ... 68
                4, ... 69
                1, ... 70
                1, ... 71
                1, ... 72
                2, ... 73
                1, ... 74
                1, ... 75
                0, ... 76
                0, ... 77
                0, ... 78
                1, ... 79
                0, ... 80
                0, ... 81
                1, ... 82
                1, ... 83
                0, ... 84
                0, ... 85
                0, ... 86
                0, ... 87
                0, ... 88
                0, ... 89
                1, ... 90
                0, ... 91
                0, ... 92
                0, ... 93
                0, ... 94
                0, ... 95
                0, ... 96
                0, ... 97
                0, ... 98
                0, ... 99
                0, ... 100
                0, ... 101
                0, ... 102
                0, ... 103
                0, ... 104
                1, ... 105
                0, ... 106
                0, ... 107
                2, ... 108
                0, ... 109
                0, ... 110
                1, ... 111
                1, ... 112
                1, ... 113
                2, ... 114
                2, ... 115
                1, ... 116
                1, ... 117
                1, ... 118
                1, ... 119
                2, ... 120
                5, ... 121
                0, ... 122
                0, ... 123
                0, ... 124
                0, ... 125
                1, ... 126
                0, ... 127
                0, ... 128
                1, ... 129
                0, ... 130
                0, ... 131
                0, ... 132
                0, ... 133
                0, ... 134
                0, ... 135
                1, ... 136
                0, ... 137
                0, ... 138
                1, ... 139
                1, ... 140
                1, ... 141
                0  ... 142
        ];
    connections(:,2) = [ ...
                4, ... 0
                3, ... 1
                3, ... 2
                1, ... 3
                1, ... 4
                1, ... 5
                3, ... 6
                3, ... 7
                1, ... 8
                1, ... 9
                1, ... 10
                4, ... 11
                2, ... 12
                1, ... 13
                1, ... 14
                1, ... 15
                1, ... 16
                1, ... 17
                4, ... 18
                2, ... 19
                1, ... 20
                2, ... 21
                1, ... 22
                1, ... 23
                1, ... 24
                1, ... 25
                1, ... 26
                1, ... 27
                1, ... 28
                1, ... 29
                1, ... 30
                1, ... 31
                1, ... 32
                1, ... 33
                1, ... 34
                1, ... 35
                4, ... 36
                1, ... 37
                1, ... 38
                1, ... 39
                3, ... 40
                1, ... 41
                2, ... 42
                2, ... 43
                1, ... 44
                2, ... 45
                0, ... 46
                0, ... 47
                0, ... 48
                0, ... 49
                0, ... 50
                0, ... 51
                0, ... 52
                0, ... 53
                0, ... 54
                0, ... 55
                2, ... 56
                0, ... 57
                0, ... 58
                0, ... 59
                0, ... 60
                1, ... 61
                0, ... 62
                0, ... 63
                0, ... 64
                0, ... 65
                1, ... 66
                0, ... 67
                0, ... 68
                0, ... 69
                0, ... 70
                1, ... 71
                1, ... 72
                3, ... 73
                0, ... 74
                0, ... 75
                0, ... 76
                0, ... 77
                0, ... 78
                0, ... 79
                0, ... 80
                0, ... 81
                0, ... 82
                0, ... 83
                0, ... 84
                0, ... 85
                0, ... 86
                1, ... 87
                0, ... 88
                0, ... 89
                1, ... 90
                1, ... 91
                0, ... 92
                0, ... 93
                0, ... 94
                0, ... 95
                0, ... 96
                0, ... 97
                1, ... 98
                0, ... 99
                0, ... 100
                1, ... 101
                0, ... 102
                0, ... 103
                1, ... 104
                1, ... 105
                1, ... 106
                2, ... 107
                1, ... 108
                1, ... 109
                2, ... 110
                0, ... 111
                0, ... 112
                0, ... 113
                0, ... 114
                0, ... 115
                0, ... 116
                0, ... 117
                0, ... 118
                0, ... 119
                0, ... 120
                0, ... 121
                0, ... 122
                0, ... 123
                0, ... 124
                0, ... 125
                0, ... 126
                0, ... 127
                0, ... 128
                1, ... 129
                0, ... 130
                1, ... 131
                0, ... 132
                0, ... 133
                1, ... 134
                1, ... 135
                0, ... 136
                1, ... 137
                1, ... 138
                0, ... 139
                0, ... 140
                0, ... 141
                0  ... 142
        ];
    connections(:,3) = [ ...
                0, ... 0
                0, ... 1
                0, ... 2
                0, ... 3
                0, ... 4
                0, ... 5
                0, ... 6
                0, ... 7
                0, ... 8
                0, ... 9
                0, ... 10
                0, ... 11
                0, ... 12
                0, ... 13
                0, ... 14
                0, ... 15
                0, ... 16
                0, ... 17
                0, ... 18
                0, ... 19
                0, ... 20
                0, ... 21
                0, ... 22
                0, ... 23
                0, ... 24
                0, ... 25
                0, ... 26
                0, ... 27
                0, ... 28
                0, ... 29
                0, ... 30
                0, ... 31
                0, ... 32
                0, ... 33
                0, ... 34
                0, ... 35
                2, ... 36
                0, ... 37
                2, ... 38
                1, ... 39
                0, ... 40
                0, ... 41
                0, ... 42
                0, ... 43
                0, ... 44
                0, ... 45
                3, ... 46
                0, ... 47
                0, ... 48
                0, ... 49
                0, ... 50
                0, ... 51
                0, ... 52
                0, ... 53
                0, ... 54
                0, ... 55
                0, ... 56
                0, ... 57
                1, ... 58
                0, ... 59
                0, ... 60
                1, ... 61
                0, ... 62
                0, ... 63
                0, ... 64
                0, ... 65
                0, ... 66
                0, ... 67
                0, ... 68
                0, ... 69
                0, ... 70
                0, ... 71
                0, ... 72
                0, ... 73
                1, ... 74
                0, ... 75
                1, ... 76
                3, ... 77
                2, ... 78
                1, ... 79
                1, ... 80
                1, ... 81
                1, ... 82
                3, ... 83
                1, ... 84
                1, ... 85
                1, ... 86
                1, ... 87
                1, ... 88
                1, ... 89
                1, ... 90
                1, ... 91
                2, ... 92
                1, ... 93
                1, ... 94
                1, ... 95
                1, ... 96
                1, ... 97
                2, ... 98
                1, ... 99
                1, ... 100
                2, ... 101
                1, ... 102
                1, ... 103
                4, ... 104
                0, ... 105
                0, ... 106
                0, ... 107
                0, ... 108
                1, ... 109
                0, ... 110
                0, ... 111
                0, ... 112
                0, ... 113
                1, ... 114
                1, ... 115
                0, ... 116
                0, ... 117
                0, ... 118
                0, ... 119
                1, ... 120
                0, ... 121
                1, ... 122
                1, ... 123
                2, ... 124
                1, ... 125
                1, ... 126
                2, ... 127
                2, ... 128
                0, ... 129
                1, ... 130
                1, ... 131
                1, ... 132
                1, ... 133
                0, ... 134
                0, ... 135
                0, ... 136
                0, ... 137
                0, ... 138
                0, ... 139
                0, ... 140
                0, ... 141
                1  ... 142
        ];
    return
end
