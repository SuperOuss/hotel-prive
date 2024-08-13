import _sequelize from "sequelize";
const { Model, Sequelize } = _sequelize;

export default class hotel extends Model {
  static init(sequelize, DataTypes) {
    return super.init({
      id: {
        autoIncrement: true,
        type: DataTypes.INTEGER,
        allowNull: false,
        primaryKey: true
      },
      name: {
        type: DataTypes.STRING(500),
        allowNull: false
      },
      address: {
        type: DataTypes.STRING(1024),        
        allowNull: true
      },
      country: {
        type: DataTypes.STRING(100),
        allowNull: false
      },
      city: {
        type: DataTypes.STRING(100),
        allowNull: false
      },
      state_province: {
        type: DataTypes.STRING(100),
        allowNull: true
      },
      stars: {
        type: DataTypes.STRING(100),
        allowNull: true
      },
      latitude: {
        type: DataTypes.FLOAT,
        allowNull: true
      },
      longitude: {
        type: DataTypes.FLOAT,
        allowNull: true
      },
      reviewsCount: {
        type: DataTypes.FLOAT,
        allowNull: true
      },
      rating: {
        type: DataTypes.FLOAT,
        allowNull: true
      },
      booking_id: {
        type: DataTypes.INTEGER,
        allowNull: true
      },
      expedia_id: {
        type: DataTypes.INTEGER,
        allowNull: true
      },      
      agoda_id: {
        type: DataTypes.INTEGER,
        allowNull: true,
      }
    }, {
      sequelize,
      tableName: 'hotel',
      timestamps: false,
      indexes: [
        {
          name: "HOTEL",
          unique: true,
          using: "BTREE",
          fields: [
            { name: "id" },
          ]
        }
      ]
    });
  }
/*   static associate(models) {
    this.hasMany(models.comments, {
      foreignKey: 'userId',
      as: 'comments'
    });
    this.hasMany(models.location, {
      foreignKey: 'userId',
      as: 'location'
    });
    this.belongsTo(models.organisation, {
      foreignKey: 'companyId',
      as: 'company'
    });
    this.hasMany(models.statusChangeLog, {
      foreignKey: 'userId',
      as: 'status_change_log'
    });
  } */
} 
