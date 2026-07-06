class Solution {
public:
    vector<int> twoSum(vector<int>& nums, int tar) {
        unordered_map<int, int> mp;
        for (int i = 0; i < nums.size(); i++) {
            int x = tar - nums[i];
            if (mp.count(x)) {
                return {i, mp[x]};
            }
            mp[nums[i]] = i;
        }
        return {};
    }
};