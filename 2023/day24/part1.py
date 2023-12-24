# load sample.txt
import re
import string
from turtle import st


class Point:
    def __init__(self, x, y, type, line):
        self.x = x
        self.y = y
        self.type = type
        self.line = line

    def __repr__(self):
        return f"({self.x}, {self.y}, {self.type}, {self.line})"


class Node:
    def __init__(self, data=None):
        self.data = data
        self.left = None
        self.right = None

    def __repr__(self):
        print("printing data: ", self.data)
        return f"({self.data}, {self.left}, {self.right})"


class BinarySearchTree:
    def __init__(self):
        self.root = None
        self.len = 0

    def __len__(self):
        return self.len

    def __repr__(self) -> str:
        if self.root is None:
            return "[]"
        return self._print_tree(self.root)

    def _print_tree(self, cur_node: Node | None) -> str:
        if cur_node:
            return (
                self._print_tree(cur_node.left)
                + str(cur_node.data)
                + self._print_tree(cur_node.right)
            )
        else:
            return "None"

    # 插入元素進入樹中
    def insert(self, data):
        self.len += 1
        if not self.root:
            self.root = Node(data)
        else:
            self._insert(data, self.root)

    def _insert(self, data, cur_node):
        if data < cur_node.data:
            if not cur_node.left:
                cur_node.left = Node(data)
            else:
                self._insert(data, cur_node.left)
        elif data > cur_node.data:
            if not cur_node.right:
                cur_node.right = Node(data)
            else:
                self._insert(data, cur_node.right)
        else:
            self.len -= 1

    # 從樹中刪除此元素
    def delete(self, data):
        self.len -= 1
        if self is None:
            return self
        if data < self.data:
            if self.left:
                self.left = self.left.delete(data)
            return self
        if data > self.data:
            if self.right:
                self.right = self.right.delete(data)
            return self
        if self.right is None:
            return self.left
        if self.left is None:
            return self.right
        aux = self.right
        while aux.left:
            aux = aux.left
        self.data = aux.data
        self.right = self.right.delete(aux.data)
        return self

    # 前序走訪
    def preOrderTraversal(self, root):
        res = []
        if root:
            res.append(root.data)
            res = res + self.preOrderTraversal(root.left)
            res = res + self.preOrderTraversal(root.right)
        return res

    # 中序走訪
    def inOrderTraversal(self, root: "BinarySearchTree | None") -> list:
        res = []
        if root:
            res = self.inOrderTraversal(root.left)
            res.append(root.data)
            res = res + self.inOrderTraversal(root.right)
        return res

    # 後序走訪
    def postOrderTraversal(self, root):
        res = []
        if root:
            res = self.postOrderTraversal(root.left)
            res = res + self.postOrderTraversal(root.right)
            res.append(root.data)
        return res

    # 搜尋此元素是否在樹中
    def search(self, data):
        if not self.data:
            return False

        if data < self.data:
            if self.left is None:
                return False
            return self.left.search(data)

        if data > self.data:
            if self.right is None:
                return False
            return self.right.search(data)

        if data == self.data:
            return True


if __name__ == "__main__":
    with open("sample.txt") as f:
        inputs = f.read().splitlines()

    # area: rectangle [x: 7, y: 7] ~ [x: 27, y: 27]
    area = [[7, 7], [27, 27]]

    # part1 ignore pz and vz
    # format: 'px, py, _pz @ vx, vy, _vz'
    # line is from [px, py] to [px + vx, py + vy], which is (7 <= px+vx <= 27) and (7 <= py+vy <= 27)

    # parse input
    lines = []
    for line in inputs:
        px, py, pz, vx, vy, vz = re.findall(r"-?\d+", line)
        ret = []
        # print("px: ", px, "py: ", py, "vx: ", vx, "vy: ", vy)
        # (ex, ey) is the end point of the line
        # (ex, ey) = (px + vx * t, py + vy * t)
        # 1. assume ex = 7
        t = (7 - int(px)) / int(vx)
        if t > 0:
            ey1 = int(py) + int(vy) * t
            if 7 <= ey1 <= 27:
                # print("(px, py): ", px, py, "(ex, ey): ", 7, ey1)
                ret.append([px, py, 7, ey1])

        # 2. assume ex = 27
        t = (27 - int(px)) / int(vx)
        if t > 0:
            ey2 = int(py) + int(vy) * t
            if 7 <= ey2 <= 27:
                # print("(px, py): ", px, py, "(ex, ey): ", 27, ey2)
                ret.append([px, py, 27, ey2])

        # 3. assume ey = 7
        t = (7 - int(py)) / int(vy)
        if t > 0:
            ex3 = int(px) + int(vx) * t
            if 7 <= ex3 <= 27:
                # print("(px, py): ", px, py, "(ex, ey): ", ex3, 7)
                ret.append([px, py, ex3, 7])

        # 4. assume ey = 27
        t = (27 - int(py)) / int(vy)
        if t > 0:
            ex4 = int(px) + int(vx) * t
            if 7 <= ex4 <= 27:
                # print("(px, py): ", px, py, "(ex, ey): ", ex4, 27)
                ret.append([px, py, ex4, 27])

        if len(ret) == 1:
            # make elm of ret to float
            lines.append(ret[0])
        elif len(ret) == 2:
            lines.append(ret[0][2:] + ret[1][2:])
    lines = [[float(elm) for elm in line] for line in lines]
    print(lines)

    # implement segment intersection algorithm

    # 一、排序所有端點：
    #     甲、X座標，從小到大。
    #     乙、Y座標，從小到大。
    #     丙、左端點先於右端點。
    #         （垂直線段，以下端點為左端點，以上端點為右端點。）
    #     丁、下端點先於上端點。
    # 二、從左往右掃描端點：
    #     甲、若為左端點，把線段塞入二元搜尋樹。
    #         判斷此線段、上一條線段是否相交。
    #         判斷此線段、下一條線段是否相交。
    #     乙、若為右端點，從二元搜尋樹取出線段。
    #         判斷上一條、下一條線段是否相交。

    # line representation: [x1, y1, x2, y2]
    # if x1 > x2, swap x1 and x2, y1 and y2
    lines = [line if line[0] <= line[2] else line[2:] + line[:2] for line in lines]

    points = []
    LEFT = 1
    RIGHT = 2
    for line in lines:
        points.append(Point(line[0], line[1], LEFT, line))
        points.append(Point(line[2], line[3], RIGHT, line))
        # points.append([line[2], line[3], RIGHT, line])

    # sort points
    points = sorted(points, key=lambda x: (x.x, x.y, x.type))
    # for point in points:
    #     print(point)

    stored_lines = BinarySearchTree()

    for point in points:
        print("len: ", len(stored_lines))
        print(stored_lines)
        if point.type == LEFT:
            print("insert line")
            print(point.line)
            stored_lines.insert(point.line)
        else:
            print("remove line")
            print(point.line)
            stored_lines.delete(point.line)


# sweep line
# use binary search tree to store lines

stored_lines = BinarySearchTree()


def cross(p1: Point, p2: Point, p3: Point) -> float:
    return (p2.x - p1.x) * (p3.y - p1.y) - (p2.y - p1.y) * (p3.x - p1.x)


def intersect1D(a: float, b: float, c: float, d: float) -> bool:
    if a > b:
        a, b = b, a
    if c > d:
        c, d = d, c
    return max(a, c) <= min(b, d)


def sgn(x: float) -> int:
    if x > 0:
        return 1
    elif x < 0:
        return -1
    else:
        return 0


def intersect(a: Point, b: Point, c: Point, d: Point) -> bool:
    if (
        intersect1D(a.x, b.x, c.x, d.x)
        and intersect1D(a.y, b.y, c.y, d.y)
        and sgn(cross(a, b, c)) * sgn(cross(a, b, d)) <= 0
        and sgn(cross(c, d, a)) * sgn(cross(c, d, b)) <= 0
    ):
        return True
    return False

    # stored_lines = []
    # for point in points:
    if point[2] == LEFT:
        # insert line
        stored_lines.insert(point[3])
        # check if intersect with previous line
        if len(stored_lines) > 1:
            for line in stored_lines.inOrderTraversal(stored_lines):
                if line != point[3]:
                    print("intersect with previous line")
                    print(line)
                    print(point[3])
        # check if intersect with next line
        if len(stored_lines) > 1:
            for line in stored_lines.inOrderTraversal(stored_lines):
                if line != point[3]:
                    print("intersect with next line")
                    print(line)
                    print(point[3])
    else:
        # remove line
        stored_lines.delete(point[3])
        # check if intersect with previous line
        if len(stored_lines) > 1:
            for line in stored_lines.inOrderTraversal(stored_lines):
                if line != point[3]:
                    print("intersect with previous line")
                    print(line)
                    print(point[3])

        # check if intersect with next line
        if len(stored_lines) > 1:
            for line in stored_lines.inOrderTraversal(stored_lines):
                if line != point[3]:
                    print("intersect with next line")
                    print(line)
                    print(point[3])
