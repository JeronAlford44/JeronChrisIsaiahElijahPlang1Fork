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

//insertion, lookup, count, inorder traversal, string description of tree
export interface BinarySearchTree<T> {
  size(): number
  insert(value: T): BinarySearchTree<T>
  contains(value: T): boolean
  inorder(): Iterable<T>

}
export class Node<T> implements BinarySearchTree<T> {
  constructor(
    public left: BinarySearchTree<T> | null,
    public value: T,
    public right: BinarySearchTree<T> | null
  ) {}
  size(): number{
    return 0
  }
  insert(value:T): BinarySearchTree<T>{

  }
  contains(value: T): boolean{
    
  }
  inorder(): Iterable<T> {
      
  }
}
export class Empty<T> implements BinarySearchTree<T>{
  treeSize = 0
  size(): number {
    return 0
  }
  insert(value: T): BinarySearchTree<T>{
    if (this.size() == 0){
      return new Node(new Empty(), value, new Empty())
    }
    switch(value){
      case
    }

    this.treeSize +=1
   
  }
  contains(value: T): boolean{
    return false
  }
  *inorder(): Iterable<T> {
    return null
      
  }

}

// Write your binary search tree implementation here
