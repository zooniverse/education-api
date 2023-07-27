# frozen_string_literal: true

require 'spec_helper'

RSpec.describe Classrooms::TeacherCreate do
  let(:current_user) { User.create! zooniverse_id: 1 }
  let(:client) { instance_double(Panoptes::Client) }
  let(:operation) { described_class.with(current_user: current_user, client: client) }
  let(:program) { create(:program) }

  it 'creates a classroom' do
    created_user_group = { 'id' => 1, 'join_token' => 'asdf' }
    allow(client).to receive_message_chain(:panoptes, :post).with('/user_groups',
                                                                  user_groups: { name: an_instance_of(String),
                                                                                 display_name: 'Kool Klass' }).and_return('user_groups' => [created_user_group])
    classroom = operation.run!  attributes: { name: 'Kool Klass', description: 'A Kool, Kool Klass For Kool Kids', school: 'Kool Skool' },
                                relationships: { program: { data: { id: program.id, type: 'program' } } }

    classroom.reload
    expect(classroom.name).to eq('Kool Klass')
    expect(program.classrooms.count).to eq(1)
    expect(classroom.program).to eq(program)
  end
end
