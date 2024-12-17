# db/seeds.rb

Machine.create!(
  [
    {
      name: "Multiplication Machine",
      description: "A machine for evaluating the binary function f(x, y) = x * y.",
      input_counts: 2,
      author: "123e4567-e89b-12d3-a456-426614174000",
      archived_at: nil,
      instructions: [
        "1. if x3 == 0 goto 9 else goto 2",
        "2. x3 = x3 - 1",
        "3. x4 = x2",
        "4. if x4 == 0 goto 8 else goto 5",
        "5. x1 = x1 + 1",
        "6. x4 = x4 - 1",
        "7. if x4 == 0 goto 8 else goto 5",
        "8. if x3 == 0 goto 9 else goto 2",
        "9. stop"
      ],
      created_at: Time.current - 7.days,
      updated_at: Time.current - 3.days
    },
    {
      name: "Division Machine",
      description: "A machine for evaluating the integer division f(x, y) = floor(x / y).",
      input_counts: 2,
      author: "987f6543-e21b-43c5-d678-112233445566",
      archived_at: nil,
      instructions: [
        "1. if x2 == 0 goto 10 else goto 2",
        "2. x4 = x3",
        "3. x2 = x2 - 1",
        "4. x4 = x4 - 1",
        "5. if x2 == 0 goto 6 else goto 7",
        "6. if x4 == 0 goto 8 else goto 10",
        "7. if x4 == 0 goto 8 else goto 3",
        "8. x1 = x1 + 1",
        "9. if x2 == 0 goto 10 else goto 2",
        "10. stop"
      ],
      created_at: Time.current - 10.days,
      updated_at: Time.current - 1.day
    },
    {
      name: "Simple Increment Machine",
      description: "A basic machine that increments the value of x1.",
      input_counts: 1,
      author: "456f7890-a12b-34c5-d678-987654321012",
      archived_at: nil,
      instructions: [
        "1. x1 = x1 + 1",
        "2. stop"
      ],
      created_at: Time.current - 15.days,
      updated_at: Time.current - 5.days
    }
  ]
)

puts "Seeded #{Machine.count} machines."
