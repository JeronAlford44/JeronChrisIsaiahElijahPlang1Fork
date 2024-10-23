import { open } from "node:fs/promises"

export function change(amount: bigint): Map<bigint, bigint> {
  if (amount < 0) {
    throw new RangeError("Amount cannot be negative")
  }
  let counts: Map<bigint, bigint> = new Map()
  let remaining = amount
  for (const denomination of [25n, 10n, 5n, 1n]) {
    counts.set(denomination, remaining / denomination)
    remaining %= denomination
  }
  return counts
}

export function firstThenApply<T,U>(
  items: T[], 
  predicate: (item: T) => boolean, 
  mutator: (item: T) => U
): U | undefined {
  for (const item of items){
    if (predicate(item)){
      return mutator(item)
    }
  }
  return undefined

}


export function* powersGenerator(base:bigint): Generator<bigint>{
  let power = 1n
  while (true){
    yield power;
    power *= base;
  }
}

export async function meaningfulLineCount(filename: string) {
  let count = 0
  const file = await open(filename, 'r')
  for await (const line of file.readLines()) {
    
    const trimmed = line.trim()
    if (trimmed && !trimmed.startsWith('#')) {
      count++
    }
  }
  return count
}


interface Sphere{
  kind: "Sphere"
  radius: number
}
interface Box {
  kind: "Box"
  width: number
  length: number
  depth: number
}
export type Shape = Sphere | Box
export function surfaceArea(shape:Shape): number{
  if (shape.kind == 'Box'){
    const [l,w,d] = [shape.length, shape.width, shape.depth]
    return 2* ((l * w) + (l* d) + (w * d)  )
  }
  return 4 * Math.PI * (shape.radius ** 2)
}
export function volume(shape: Shape): number{
  if (shape.kind == 'Box'){
    return  shape.width * shape.length * shape.depth
  }
  return (4 / 3) * Math.PI * (shape.radius**3)
}


export interface BinarySearchTree<T> {
  size(): number;
  insert(value: T): BinarySearchTree<T>;
  contains(value: T): boolean;
  inorder(): Iterable<T>;
  toString(): string;
}

class Node<T> implements BinarySearchTree<T> {
  constructor(
    public left: BinarySearchTree<T>, 
    public value: T, 
    public right: BinarySearchTree<T>
  ) {}

  size(): number {
    return 1 + this.left.size() + this.right.size();
  }

  insert(value: T): BinarySearchTree<T> {
    if (value < this.value) {
      return new Node(this.left.insert(value), this.value, this.right);
    } else if (value > this.value) {
      return new Node(this.left, this.value, this.right.insert(value));
    }
    return this;
  }

  contains(value: T): boolean {
    if (value === this.value) {
      return true;
    } else if (value < this.value) {
      return this.left.contains(value);
    } else {
      return this.right.contains(value);
    }
  }

  *inorder(): Iterable<T> {
    yield* this.left.inorder();
    yield this.value;
    yield* this.right.inorder();
  }

  toString(): string {
    
    const leftSubstring = this.left.toString();
    const rightSubstring = this.right.toString();
    const leftPart = leftSubstring !== '()' ? leftSubstring : ''
    const rightPart = rightSubstring !== '()' ? rightSubstring : ''
    return `(${leftPart}${this.value}${rightPart})`;
  }
}

export class Empty<T> implements BinarySearchTree<T> {
  size(): number {
    return 0;
  }

  insert(value: T): BinarySearchTree<T> {
    return new Node(new Empty(), value, new Empty());
  }

  contains(value: T): boolean {
    return false;
  }

  *inorder(): Iterable<T> {
    
  }

  toString(): string {
    return `()`;
  }
}
