DatabaseCleaner.clean_with(:truncation)

users = []
7.times do |n|
 users <<  User.create(
            email: "foobar-#{n}@foobar.com",
            password: 'foobar',
            password_confirmation: 'foobar'
          )
end

seed_notes = lambda do |user, amount|
  hashtags = []
  (amount / 2).times { hashtags << '#' + Faker::Hipster.word }
  mentions = []
  (amount / 2).times { mentions << '@' + Faker::Name.first_name}

  notes = []
  (amount.to_int * 7 / 8).times do
    title = ""
    (rand(0..1)).times { title += "#{hashtags.sample} " }
    (rand(0..1)).times { title += "#{mentions.sample} " }
    title += [true, false].sample ? "" : Faker::Hipster.sentence(rand(1..3), false, 0).chop

    body = ""
    (rand(0..2)).times { body += "#{hashtags.sample} " }
    (rand(0..2)).times { body += "#{mentions.sample} "}
    body += Faker::Hipster.paragraph(rand(1..3))

    notes << user.notes.create(title: title, body: body)
  end

  (amount.to_int / 8).times do
    title = [true, false].sample ? "" : Faker::Hipster.sentence(rand(1..3), false, 0)
    body = Faker::Hipster.paragraph(rand(1..3))

    notes << user.notes.create(title: title, body: body)
  end

  notes.shuffle!
  l = notes.length
  day = 86400
  notes[0...l/4].each do |note|
    note.update!(created_at: note.created_at - rand(0..6)*day, updated_at: note.updated_at - 6*day)
  end
  notes[l/4...l*2/4].each do |note|
    note.update!(created_at: note.created_at - rand(14..30)*day, updated_at: note.updated_at - 30*day)
  end
  notes[l*2/4...l*3/4].each do |note|
    note.update!(created_at: note.created_at - rand(180..364)*day, updated_at: note.updated_at - 364*day)
  end
  notes[l*3/4..-1].each do |note|
    note.update!(created_at: note.created_at - rand(400..500)*day, updated_at: note.updated_at - 400*day)
  end
end

users.each {|user| seed_notes.call(user, 16)}
