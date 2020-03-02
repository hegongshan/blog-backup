---
title: LeetCode 946.验证栈序列/《剑指Offer》31.栈的压入、弹出序列
date: 2019-06-01 17:01:28
tags: stack
categories: leetcode
---

给定 `pushed` 和 `popped` 两个序列，只有当它们可能是在最初空栈上进行的推入 push 和弹出 pop 操作序列的结果时，返回 `true`；否则，返回 `false` 。

<!--more-->

**示例 1：**

```
输入：pushed = [1,2,3,4,5], popped = [4,5,3,2,1]
输出：true
解释：我们可以按以下顺序执行：
push(1), push(2), push(3), push(4), pop() -> 4,
push(5), pop() -> 5, pop() -> 3, pop() -> 2, pop() -> 1
```

**示例 2：**

```
输入：pushed = [1,2,3,4,5], popped = [4,3,5,1,2]
输出：false
解释：1 不能在 2 之前弹出。
```

** 提示：**

1. `0 <= pushed.length == popped.length <= 1000`
2. `0 <= pushed[i], popped[i] < 1000`
3. `pushed` 是 `popped` 的排列。

### 解决方案

* **思路：**模拟进出栈操作。

对pushed中的每一个元素执行如下操作：

1.将该元素进栈；

2.当栈不为空时，判断栈顶元素与popped中的当前元素popped[j]是否相等。若相等，则执行出栈操作，且j++。循环执行该操作，直到条件不满足为止。

待上述操作执行完后，判断栈是否为空。若栈空，则表示给定的栈序列是合法的；否则，则不合法。

```java
class Solution {
    public boolean validateStackSequences(int[] pushed, int[] popped) {
        if(pushed == null || popped == null || pushed.length != popped.length) {
            return false;
        }
        // 用一个数组模拟栈的操作
        int[] stack = new int[pushed.length];
        // 栈的实际长度
        int len = 0;
        for (int i = 0, j = 0; i < pushed.length; i++) {
            // 1.进栈
            stack[len++] = pushed[i];
            // 2.栈不为空时，循环判断栈顶元素与popped的当前元素是否相等
            while(len != 0 && stack[len-1] == popped[j]) {
                // 出栈
                len--;
                j++;
            }
        }
        return len == 0;
    }
}
```

当然，我们也可以使用Stack类来实现上述操作。

```java
class Solution {
    public boolean validateStackSequences(int[] pushed, int[] popped) {
        if(pushed == null || popped == null || pushed.length != popped.length) {
            return false;
        }

        Stack<Integer> stack = new Stack<>();          
        for (int i = 0, j = 0; i < pushed.length; i++) {   
            stack.push(pushed[i]);        
            while (!stack.empty() && stack.peek() == popped[j]) {
                stack.pop();
                j++;
            }
        }
        return stack.empty();
    }
}
```

复杂度分析：时间复杂度和空间复杂度均为O(n)。其中，n表示pushed序列的长度。